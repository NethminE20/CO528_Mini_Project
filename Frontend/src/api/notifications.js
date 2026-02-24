import axios from 'axios';

const NOTIFICATION_URL =
  import.meta.env.VITE_NOTIFICATION_URL || 'http://localhost:5006';

const notificationAPI = axios.create({ baseURL: NOTIFICATION_URL });

export const getNotifications = () => notificationAPI.get('/');
export const createNotification = (data) => notificationAPI.post('/', data);
