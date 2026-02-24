import { useEffect, useState } from 'react';
import { getJobs, createJob, updateJob, deleteJob } from '../../api/services';
import { toast } from 'react-toastify';
import { FiEdit2, FiTrash2, FiPlus } from 'react-icons/fi';

export default function Jobs() {
  const [jobs, setJobs] = useState([]);
  const [showModal, setShowModal] = useState(false);
  const [editing, setEditing] = useState(null);
  const [form, setForm] = useState({ title: '', description: '', company: '' });

  const fetchData = async () => {
    try {
      const res = await getJobs();
      setJobs(Array.isArray(res.data) ? res.data : []);
    } catch {
      /* ignore */
    }
  };

  useEffect(() => {
    fetchData();
  }, []);

  const openCreate = () => {
    setEditing(null);
    setForm({ title: '', description: '', company: '' });
    setShowModal(true);
  };

  const openEdit = (job) => {
    setEditing(job);
    setForm({ title: job.title, description: job.description, company: job.company });
    setShowModal(true);
  };

  const handleChange = (e) => setForm({ ...form, [e.target.name]: e.target.value });

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      if (editing) {
        await updateJob(editing._id, form);
        toast.success('Job updated successfully');
      } else {
        await createJob(form);
        toast.success('Job created successfully');
      }
      setShowModal(false);
      fetchData();
    } catch {
      toast.error('Operation failed');
    }
  };

  const handleDelete = async (id) => {
    if (!window.confirm('Delete this job?')) return;
    try {
      await deleteJob(id);
      toast.success('Job deleted');
      fetchData();
    } catch {
      toast.error('Delete failed');
    }
  };

  return (
    <>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <h1>Jobs</h1>
        <button className="btn btn-primary" onClick={openCreate}><FiPlus /> New Job</button>
      </div>

      <div className="card" style={{ marginTop: '1rem' }}>
        <table>
          <thead>
            <tr>
              <th>Title</th>
              <th>Company</th>
              <th>Description</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            {jobs.map((j) => (
              <tr key={j._id}>
                <td>{j.title}</td>
                <td>{j.company}</td>
                <td>{j.description?.substring(0, 80)}…</td>
                <td className="action-btns">
                  <button className="btn btn-sm btn-outline-primary" onClick={() => openEdit(j)} title="Edit"><FiEdit2 /> Edit</button>
                  <button className="btn btn-sm btn-outline-danger" onClick={() => handleDelete(j._id)} title="Delete"><FiTrash2 /> Delete</button>
                </td>
              </tr>
            ))}
            {jobs.length === 0 && (
              <tr><td colSpan={4} style={{ textAlign: 'center', padding: '2rem' }}>No jobs yet.</td></tr>
            )}
          </tbody>
        </table>
      </div>

      {showModal && (
        <div className="modal-backdrop" onClick={() => setShowModal(false)}>
          <div className="modal" onClick={(e) => e.stopPropagation()}>
            <h2>{editing ? 'Edit Job' : 'Create Job'}</h2>
            <form onSubmit={handleSubmit}>
              <div className="form-group">
                <label>Title</label>
                <input name="title" required value={form.title} onChange={handleChange} />
              </div>
              <div className="form-group">
                <label>Company</label>
                <input name="company" required value={form.company} onChange={handleChange} />
              </div>
              <div className="form-group">
                <label>Description</label>
                <textarea name="description" rows={4} required value={form.description} onChange={handleChange} />
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
