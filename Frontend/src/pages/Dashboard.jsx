import { useAuth } from '../context/AuthContext';
import { useNavigate } from 'react-router-dom';
import { FiFileText, FiBriefcase, FiCalendar, FiMessageSquare, FiBarChart2, FiBell } from 'react-icons/fi';

const cards = [
  { label: 'Posts', desc: 'View & create posts', icon: FiFileText, path: '/posts', gradient: 'linear-gradient(135deg, #6366f1, #818cf8)' },
  { label: 'Jobs', desc: 'Browse job listings', icon: FiBriefcase, path: '/jobs', gradient: 'linear-gradient(135deg, #10b981, #34d399)' },
  { label: 'Events', desc: 'Upcoming events & RSVP', icon: FiCalendar, path: '/events', gradient: 'linear-gradient(135deg, #f59e0b, #fbbf24)' },
  { label: 'Chat', desc: 'Real-time messaging', icon: FiMessageSquare, path: '/messaging', gradient: 'linear-gradient(135deg, #8b5cf6, #a78bfa)' },
  { label: 'Analytics', desc: 'Platform insights', icon: FiBarChart2, path: '/analytics', gradient: 'linear-gradient(135deg, #06b6d4, #67e8f9)' },
  { label: 'Notifications', desc: 'Stay updated', icon: FiBell, path: '/notifications', gradient: 'linear-gradient(135deg, #ef4444, #f87171)' },
];

export default function Dashboard() {
  const { user } = useAuth();
  const navigate = useNavigate();

  return (
    <>
      <div style={{ marginBottom: '2rem' }}>
        <h1 style={{ fontSize: '2rem', marginBottom: '0.35rem' }}>
          Welcome back{user?.name ? `, ${user.name}` : ''} 👋
        </h1>
        <p style={{ color: 'var(--text-muted)', fontSize: '1rem' }}>
          DECP Platform — Department of Computer Engineering Community Portal
        </p>
      </div>

      <div className="analytics-grid">
        {cards.map((c) => (
          <div
            className="stat-card"
            key={c.path}
            onClick={() => navigate(c.path)}
            style={{ cursor: 'pointer' }}
          >
            <div
              style={{
                width: 52,
                height: 52,
                borderRadius: 14,
                background: c.gradient,
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                margin: '0 auto 1rem',
                boxShadow: `0 4px 14px ${c.gradient.includes('#6366f1') ? 'rgba(99,102,241,0.3)' : 'rgba(0,0,0,0.1)'}`,
              }}
            >
              <c.icon size={24} color="#fff" />
            </div>
            <div className="stat-value" style={{ fontSize: '1.25rem' }}>{c.label}</div>
            <div className="stat-label">{c.desc}</div>
          </div>
        ))}
      </div>
    </>
  );
}
