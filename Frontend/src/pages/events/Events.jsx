import { useEffect, useState } from 'react';
import { getEvents, createEvent, updateEvent, deleteEvent, rsvpEvent } from '../../api/services';
import { useAuth } from '../../context/AuthContext';
import { toast } from 'react-toastify';
import { FiEdit2, FiTrash2, FiPlus, FiCheckCircle } from 'react-icons/fi';

export default function Events() {
  const { user } = useAuth();
  const [events, setEvents] = useState([]);
  const [showModal, setShowModal] = useState(false);
  const [editing, setEditing] = useState(null);
  const [form, setForm] = useState({ title: '', date: '' });

  const fetchData = async () => {
    try {
      const res = await getEvents();
      setEvents(Array.isArray(res.data) ? res.data : []);
    } catch {
      /* ignore */
    }
  };

  useEffect(() => {
    fetchData();
  }, []);

  const openCreate = () => {
    setEditing(null);
    setForm({ title: '', date: '' });
    setShowModal(true);
  };

  const openEdit = (ev) => {
    setEditing(ev);
    setForm({ title: ev.title, date: ev.date?.substring(0, 10) || '' });
    setShowModal(true);
  };

  const handleChange = (e) => setForm({ ...form, [e.target.name]: e.target.value });

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      if (editing) {
        await updateEvent(editing._id, form);
        toast.success('Event updated successfully');
      } else {
        await createEvent(form);
        toast.success('Event created successfully');
      }
      setShowModal(false);
      fetchData();
    } catch {
      toast.error('Operation failed');
    }
  };

  const handleDelete = async (id) => {
    if (!window.confirm('Delete this event?')) return;
    try {
      await deleteEvent(id);
      toast.success('Event deleted');
      fetchData();
    } catch {
      toast.error('Delete failed');
    }
  };

  const handleRsvp = async (id) => {
    try {
      await rsvpEvent(id, { userId: user?.email || 'anonymous' });
      toast.success('RSVP confirmed!');
      fetchData();
    } catch {
      toast.error('RSVP failed');
    }
  };

  return (
    <>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <h1>Events</h1>
        <button className="btn btn-primary" onClick={openCreate}><FiPlus /> New Event</button>
      </div>

      <div className="card" style={{ marginTop: '1rem' }}>
        <table>
          <thead>
            <tr>
              <th>Title</th>
              <th>Date</th>
              <th>RSVPs</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            {events.map((ev) => (
              <tr key={ev._id}>
                <td>{ev.title}</td>
                <td>{ev.date ? new Date(ev.date).toLocaleDateString() : '—'}</td>
                <td>{ev.rsvps?.length ?? 0}</td>
                <td className="action-btns">
                  <button className="btn btn-sm btn-outline-success" onClick={() => handleRsvp(ev._id)} title="RSVP"><FiCheckCircle /> RSVP</button>
                  <button className="btn btn-sm btn-outline-primary" onClick={() => openEdit(ev)} title="Edit"><FiEdit2 /> Edit</button>
                  <button className="btn btn-sm btn-outline-danger" onClick={() => handleDelete(ev._id)} title="Delete"><FiTrash2 /> Delete</button>
                </td>
              </tr>
            ))}
            {events.length === 0 && (
              <tr><td colSpan={4} style={{ textAlign: 'center', padding: '2rem' }}>No events yet.</td></tr>
            )}
          </tbody>
        </table>
      </div>

      {showModal && (
        <div className="modal-backdrop" onClick={() => setShowModal(false)}>
          <div className="modal" onClick={(e) => e.stopPropagation()}>
            <h2>{editing ? 'Edit Event' : 'Create Event'}</h2>
            <form onSubmit={handleSubmit}>
              <div className="form-group">
                <label>Title</label>
                <input name="title" required value={form.title} onChange={handleChange} />
              </div>
              <div className="form-group">
                <label>Date</label>
                <input name="date" type="date" required value={form.date} onChange={handleChange} />
              </div>
              <div className="modal-actions">
                <button type="button" className="btn" onClick={() => setShowModal(false)}>Cancel</button>
                <button type="submit" className="btn btn-primary">{editing ? 'Update' : 'Create'}</button>
              </div>
            </form>
          </div>
        </div>
      )}
    </>
  );
}
