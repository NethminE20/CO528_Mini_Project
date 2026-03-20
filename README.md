CO528_Mini_Project 
# DECP — Department Engagement & Career Platform

A microservices-based social and career platform for students and alumni of the Department of Computer Engineering, University of Peradeniya. Built by **Team Nexus CE** for CO528 Applied Software Architecture.

## Overview

DECP connects current students and alumni through a unified web and mobile experience — enabling social posting, job/internship applications, event participation, research collaboration, and real-time messaging.

## Features

- **User Management** — Register, login, JWT-based auth with role-based access
- **Feed & Posts** — Text and image posts with likes and comments
- **Jobs & Internships** — Post and apply for opportunities
- **Events** — Browse, RSVP, and receive notifications
- **Real-time Messaging** — WebSocket-powered chat (Socket.IO)
- **Research Collaboration** — Project sharing and team invites
- **Analytics Dashboard** — Department-level insights on active users and popular content
- **Notifications** — Event-driven push notifications

## Tech Stack

| Layer | Technology |
|---|---|
| Backend | Node.js / Express (microservices) |
| Database | MongoDB (Mongoose) |
| Auth | JWT + role-based access control |
| Real-time | Socket.IO (WebSockets) |
| Message Queue | RabbitMQ |
| Frontend | React (Vite) |
| Mobile | Flutter |
| Reverse Proxy | Nginx |
| Cloud | AWS |
| Containerisation | Docker / Docker Compose |

## Architecture

The platform follows a **Service-Oriented Architecture (SOA)** with eight independent microservices behind an API Gateway, all connected via a shared Docker bridge network (`decp-network`).

```
Client (React Web / Flutter Mobile)
        │
      Nginx (Port 80)
        │
   API Gateway (5000)
   ┌────┴──────────────────────────┐
   │                               │
User(5001)  Post(5002)  Job(5003)  Event(5004)  Analytics(5007)
                    Messaging(5005)  Notifications(5006)
                               │
                            MongoDB
```

### Service Port Map

| Service | Port |
|---|---|
| API Gateway | 5000 |
| User Service | 5001 |
| Post Service | 5002 |
| Job Service | 5003 |
| Event Service | 5004 |
| Messaging Service | 5005 |
| Notification Service | 5006 |
| Analytics Service | 5007 |

## Getting Started

### Prerequisites

- Docker & Docker Compose installed
- Git

### Run Locally

```bash
git clone https://github.com/NethminE20/CO528_Mini_Project
cd CO528_Mini_Project
docker compose up --build
```

The app will be available at `http://localhost`.

### Environment Variables

| Variable | Description |
|---|---|
| `JWT_SECRET` | Secret key for JWT signing |
| `MONGO_URI` | MongoDB connection string |

## API Overview

| Service | Sample Endpoints |
|---|---|
| User | `POST /users/register`, `POST /users/login`, `GET /users/profile` |
| Post/Feed | `GET /posts/feed`, `POST /posts`, `POST /posts/like`, `POST /posts/comment` |
| Jobs | `GET /jobs`, `POST /jobs/apply` |
| Events | `GET /events`, `POST /events/rsvp` |
| Research | `GET /projects`, `POST /projects/share-doc`, `POST /projects/invite` |
| Messaging | `WebSocket /chat` |
| Analytics | `GET /analytics` |

All APIs are documented with OpenAPI specs.

## Team

| Student ID | Name |
|---|---|
| E/20/404 | Ukwaththa U.A.N.T. |
| E/20/318 | Ranawaka R.A.D.J.I |
| E/20/016 | Amarakeerthi H.K.K.G. |
| E/20/243 | Malintha K.M.K. |
| E/20/231 | Madhura T.W.K.I. |

## License

This project was developed for academic purposes as part of CO528 Applied Software Architecture at the University of Peradeniya.
