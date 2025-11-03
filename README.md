# Rails App Deployment with Kamal and DigitalOcean

### Steps for deploy

#### 1. Initial setup:
1. Created a new Droplet on DigitalOcean.  
2. Installed Docker and granted user permissions with:
   ```bash
   sudo apt update
   sudo apt install docker.io
   sudo usermod -aG docker $USER
   ```
3. Check if Kamal is in the Gemfile, if not run:
   ```bash
   gem install kamal
   ```
4. Initialize Kamal inside the project directory:
   ```bash
   kamal init
   ```
   _This creates the base files to set up Kamal (later on)._

---

#### 2. Configuring Kamal
1. Adjust the `deploy.yml` file to match the project and server:
   2. Change the image to sync with Docker Hub.  
   3. Change the server to the IP given from DigitalOcean.  
   4. Change the environment to use `production`.  
   5. Add secrets `RAILS_MASTER_KEY` and `DATABASE_URL` under `env`.  
   6. Change the proxy values to match the IP and disable SSL (since we don’t have a domain, we use plain HTTP).

7. **Export required environment variables** before running any deploy commands:
   ```bash
   export KAMAL_REGISTRY_USERNAME="juancabellovargas"
   export KAMAL_REGISTRY_PASSWORD="your_dockerhub_token"
   export RAILS_MASTER_KEY=$(cat config/master.key)
   ```
   _This allows Kamal to log in to Docker Hub and access your Rails secrets during deployment._

---

#### 3. Docker registry
Due to several complications with the local registry, the setup was changed to use Docker Hub instead.  
This required changing the registry server to:  
`registry: registry.hub.docker.com`  
and using the username `juancabellovargas` (the Docker Hub account created for this project).

---

#### 4. First deploy
1. Once the setup was complete, run:

   ```bash
   kamal setup
   ```

2. When the setup finished successfully, deploy the app:

   ```bash
   kamal deploy
   ```

This step gave a few problems such as:

##### 1. Problem 1 - Permission denied with Docker
**Error:**
```bash
permission denied while trying to connect to the Docker daemon socket
```
**Fix:** Add the user to the Docker group:
```bash
sudo usermod -aG docker $USER
```

##### 2. Problem 2 - "Target failed to become healthy"
**Error:**
```pgsql
target failed to become healthy within configured timeout
```

**Fix:**
1. Verified the database configuration in `config/database.yml`.
2. Created role and database on the server:
   - SSH into the droplet: `ssh root@<ip>`
   - Ensure PostgreSQL is installed:
     ```bash
     which psql
     sudo apt install -y postgresql
     ```
   - Create the role and database manually.
   - Confirm PostgreSQL listens on port 5432.
   - Test connection with:  
     `DATABASE_URL=postgres://user:password@157.245.180.198:5432/databaseName`
3. Ensured the production environment variables were set in `.kamal/secrets`.

---

#### 5. Proxy configuration
When visiting the server IP before the first deploy without errors, the page showed a blue **404 error from Kamal Proxy**.  
That meant the proxy was running but not linked to the Rails container.

**Fix:**  
Updated the proxy section in `deploy.yml` and redeployed:

```bash
kamal deploy
```

---

#### 6. Internal Server Error (500)
After fixing the proxy, the app loaded — but showed a **Rails 500 Internal Server Error**.  

To identify the cause:
```bash
kamal app logs
```

**Output:**
```bash
ActionView::Template::Error (undefined local variable or method 'categories_path')
```

**Cause:**  
The layout had a reference to `categories_path`, a route that didn’t exist (copied from a previous lab’s navbar).

**Fix:**  
Reverted to the working navbar from lab-08.  

After committing the fix:
```bash
git add app/views/layouts/application.html.erb
git commit -m "fix: Fixed layout"
kamal deploy
```

The application loaded successfully.
