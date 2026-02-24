import { useEffect, useState } from 'react';
import { getNotifications, createNotification } from '../../api/notifications';

export default function Notifications() {
  const [notifications, setNotifications] = useState([]);
  const [showForm, setShowForm] = useState(false);
  const [form, setForm] = useState({ title: '', message: '' });

  const fetchData = async () => {
    try {
      const res = await getNotifications();
      const list = Array.isArray(res.data) ? res.data : res.data?.notifications ?? [];
      setNotifications(list);
    } catch {
      /* ignore */
    }
  };

  useEffect(() => {
    fetchData();
  }, []);

  const handleChange = (e) => setForm({ ...form, [e.target.name]: e.target.value });

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      await createNotification(form);
      setForm({ title: '', message: '' });
      setShowForm(false);
      fetchData();
    } catch {
      /* ignore */
    }
  };

  return (
    <>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <h1>Notifications</h1>
        <button className="btn btn-primary" onClick={() => setShowForm(!showForm)}>
          {showForm ? 'Cancel' : '+ Create Notification'}
        </button>
      </div>

      {showForm && (
        <div className="card" style={{ marginTop: '1rem' }}>
          <h2 style={{ fontSize: '1.1rem', marginBottom: '0.75rem' }}>New Notification (Admin)</h2>
          <form onSubmit={handleSubmit}>
            <div className="form-group">
              <label>Title</label>
              <input name="title" required value={form.title} onChange={handleChange} />
            </div>
            <div className="form-group">
              <label>Message</label>
              <textarea name="message" rows={3} required value={form.message} onChange={handleChange} />
            </div>
            <button type="submit" className="btn btn-primary">Send Notification</button>
          </form>
        </div>
      )}

      <div className="card" style={{ marginTop: '1rem' }}>
        {notifications.length === 0 && (
          <p style={{ textAlign: 'center', color: '#999', padding: '2rem' }}>No notifications.</p>
        )}
        {notifications.map((n, idx) => (
          <div className="notification-item" key={n._id || idx}>
            <div className="dot" />
            <div className="notif-body">
              <div className="title">{n.title || 'Notification'}</div>
              <div className="desc">{n.message || n.body || ''}</div>
            </div>
          </div>
        ))}
      </div>
    </>
  );
}
