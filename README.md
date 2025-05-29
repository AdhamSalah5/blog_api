# Blog API

A RESTful JSON API for a blog platform built with **Ruby on Rails 8**, featuring user authentication, posts, comments, and background job processing using **Sidekiq**.

---

## 📦 Features

- **JWT Authentication** for login and protected routes  
- Full **CRUD** for Posts and Comments  
- Posts include tags (stored as JSON)  
- Sidekiq-powered background jobs (e.g., deleting posts after 24 hours)  
- Graceful error handling (404s, auth errors, etc.)  
- API-only mode (no views)  
- Dockerized for easy development & deployment  

---

## ⚙️ Setup Instructions

### Prerequisites

- Docker & Docker Compose  
- Git  

### Clone and Run

```bash
git clone https://github.com/AdhamSalah5/blog_api.git
cd blog_api
docker-compose up --build
```

### Run Migrations

```bash
docker-compose exec web rails db:prepare
```

---

## 📌 API Overview

All endpoints return JSON. Include the following header in authorized requests:

```
Authorization: Bearer <your_jwt_token>
```

### 🔐 Authentication

| Method | Endpoint       | Description         |
|--------|----------------|---------------------|
| POST   | /auth/signup   | Register new user   |
| POST   | /auth/login    | Login & get token   |

---

### 📝 Posts

| Method | Endpoint        | Description               |
|--------|-----------------|---------------------------|
| GET    | /posts          | List all posts            |
| GET    | /posts/:id      | View a single post        |
| POST   | /posts          | Create post *(auth)*      |
| PUT    | /posts/:id      | Update post *(owner)*     |
| DELETE | /posts/:id      | Delete post *(owner)*     |

> **Note:** Each post must have at least one tag (as an array of strings).

---

### 💬 Comments

| Method | Endpoint                              | Description               |
|--------|---------------------------------------|---------------------------|
| GET    | /posts/:post_id/comments              | List comments for a post  |
| POST   | /posts/:post_id/comments              | Create comment *(auth)*   |
| PUT    | /posts/:post_id/comments/:id          | Update *(owner only)*     |
| DELETE | /posts/:post_id/comments/:id          | Delete *(owner only)*     |

---

## 🛠 Tech Stack

- **Ruby on Rails 8** (API only)  
- **PostgreSQL** – primary database  
- **Redis** – job queue storage  
- **Sidekiq** – background job processor  
- **JWT** – JSON Web Tokens for auth  
- **Docker** – containerization  

---

## 🔧 Background Jobs

- `DeletePostJob` automatically deletes posts 24 hours after creation.
- Enqueued via `after_create` callback in the `Post` model.

### Start Sidekiq

```bash
docker-compose exec web bundle exec sidekiq
```

---

## 🧪 Testing

Basic tests cover:

- Authentication
- Posts
- Comments
- Authorization rules

### Run tests

```bash
docker-compose exec web rails test
```

---

## 🔐 Environment Variables

Defined in `docker-compose.yml`:

```env
RAILS_ENV=development
DATABASE_URL=postgres://blog_user:blog_password@db:5432/blog_api_development
REDIS_URL=redis://redis:6379/1
```

---
