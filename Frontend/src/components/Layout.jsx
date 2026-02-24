import { NavLink, Outlet, useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { useEffect, useState } from 'react';
import { getNotifications } from '../api/notifications';
import {
  FiHome,
  FiFileText,
  FiBriefcase,
  FiCalendar,
  FiBarChart2,
  FiMessageSquare,
  FiBell,
  FiMenu,
  FiX,
} from 'react-icons/fi';

export default function Layout() {
  const { user, logout, isAuthenticated } = useAuth();
  const navigate = useNavigate();
  const [notifCount, setNotifCount] = useState(0);
  const [collapsed, setCollapsed] = useState(false);

  useEffect(() => {
    getNotifications()
      .then((res) => {
        const list = Array.isArray(res.data) ? res.data : res.data?.notifications ?? [];
        setNotifCount(list.length);
      })
      .catch(() => {});
  }, []);

  const handleLogout = () => {
    logout();
    navigate('/login');
  };

  return (
    <div className={`app-layout ${collapsed ? 'sidebar-collapsed' : ''}`}>
      {/* Sidebar */}
      <aside className={`sidebar ${collapsed ? 'collapsed' : ''}`}>
        <div className="brand-row">
          {!collapsed && <div className="brand">DECP Platform</div>}
          <button
            className="collapse-btn"
            onClick={() => setCollapsed(!collapsed)}
            title={collapsed ? 'Expand sidebar' : 'Collapse sidebar'}
          >
            {collapsed ? <FiMenu /> : <FiX />}
          </button>
        </div>
        <nav>
          <NavLink to="/" end title="Dashboard">
            <FiHome /> {!collapsed && 'Dashboard'}
          </NavLink>
          <NavLink to="/posts" title="Posts">
            <FiFileText /> {!collapsed && 'Posts'}
          </NavLink>
          <NavLink to="/jobs" title="Jobs">
            <FiBriefcase /> {!collapsed && 'Jobs'}
          </NavLink>
          <NavLink to="/events" title="Events">
            <FiCalendar /> {!collapsed && 'Events'}
          </NavLink>
          <NavLink to="/analytics" title="Analytics">
            <FiBarChart2 /> {!collapsed && 'Analytics'}
          </NavLink>
          <NavLink to="/messaging" title="Messaging">
            <FiMessageSquare /> {!collapsed && 'Messaging'}
          </NavLink>
          <NavLink to="/notifications" title="Notifications">
            <FiBell /> {!collapsed && 'Notifications'}
          </NavLink>
        </nav>
        {isAuthenticated && (
          <button className="logout-btn" onClick={handleLogout}>
            {collapsed ? '✕' : 'Logout'}
          </button>
        )}
      </aside>

      {/* Main area */}
      <div className="main-content">
        {/* Top bar */}
        <header className="topbar">
          <span
            className="bell"
            onClick={() => navigate('/notifications')}
            title="Notifications"
          >
            <FiBell />
            {notifCount > 0 && <span className="badge">{notifCount}</span>}
          </span>
          <span className="user-info">{user?.name || 'Guest'}</span>
        </header>

        {/* Page content */}
        <div className="page">
          <Outlet />
        </div>
      </div>
    </div>
  );
}
