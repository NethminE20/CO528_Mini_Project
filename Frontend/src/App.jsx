import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider, useAuth } from './context/AuthContext';

import Layout from './components/Layout';
import Login from './pages/auth/Login';
import Register from './pages/auth/Register';
import Dashboard from './pages/Dashboard';
import Posts from './pages/posts/Posts';
import Jobs from './pages/jobs/Jobs';
import Events from './pages/events/Events';
import Analytics from './pages/analytics/Analytics';
import Messaging from './pages/messaging/Messaging';
import Notifications from './pages/notifications/Notifications';

function PrivateRoute({ children }) {
  const { isAuthenticated } = useAuth();
  return isAuthenticated ? children : <Navigate to="/login" replace />;
  return children; // TODO: remove this bypass after testing
}

export default function App() {
  return (
    <AuthProvider>
      <BrowserRouter>
        <Routes>
          {/* Public routes */}
          <Route path="/login" element={<Login />} />
          <Route path="/register" element={<Register />} />

          {/* Protected routes with layout */}
          <Route
            path="/"
            element={
              <PrivateRoute>
                <Layout />
              </PrivateRoute>
            }
          >
            <Route index element={<Dashboard />} />
            <Route path="posts" element={<Posts />} />
            <Route path="jobs" element={<Jobs />} />
            <Route path="events" element={<Events />} />
            <Route path="analytics" element={<Analytics />} />
            <Route path="messaging" element={<Messaging />} />
            <Route path="notifications" element={<Notifications />} />
          </Route>

          {/* Catch-all */}
          <Route path="*" element={<Navigate to="/" replace />} />
        </Routes>
      </BrowserRouter>
    </AuthProvider>
  );
}
