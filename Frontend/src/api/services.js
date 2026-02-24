import API from './axios';

// ─── Auth / Users ───────────────────────────────────────
export const registerUser = (data) => API.post('/users/register', data);
export const loginUser = (data) => API.post('/users/login', data);

// ─── Posts ──────────────────────────────────────────────
export const getPosts = () => API.get('/posts');
export const createPost = (data) => API.post('/posts', data);
export const updatePost = (id, data) => API.put(`/posts/${id}`, data);
export const deletePost = (id) => API.delete(`/posts/${id}`);

// ─── Jobs ───────────────────────────────────────────────
export const getJobs = () => API.get('/jobs');
export const createJob = (data) => API.post('/jobs', data);
export const updateJob = (id, data) => API.put(`/jobs/${id}`, data);
export const deleteJob = (id) => API.delete(`/jobs/${id}`);

// ─── Events ─────────────────────────────────────────────
export const getEvents = () => API.get('/events');
export const createEvent = (data) => API.post('/events', data);
export const updateEvent = (id, data) => API.put(`/events/${id}`, data);
export const deleteEvent = (id) => API.delete(`/events/${id}`);
export const rsvpEvent = (id, data) => API.post(`/events/${id}/rsvp`, data);

// ─── Analytics ──────────────────────────────────────────
export const getAnalytics = () => API.get('/analytics');
