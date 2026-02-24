import { useEffect, useState } from 'react';
import { getPosts, createPost, updatePost, deletePost } from '../../api/services';
import { useAuth } from '../../context/AuthContext';

export default function Posts() {
  const { user } = useAuth();
  const [posts, setPosts] = useState([]);
  const [showModal, setShowModal] = useState(false);
  const [editing, setEditing] = useState(null);
  const [form, setForm] = useState({ content: '' });

  const fetchData = async () => {
    try {
      const res = await getPosts();
      setPosts(Array.isArray(res.data) ? res.data : []);
    } catch {
      /* ignore */
    }
  };

  useEffect(() => {
    fetchData();
  }, []);

  const openCreate = () => {
    setEditing(null);
    setForm({ content: '' });
    setShowModal(true);
  };

  const openEdit = (post) => {
    setEditing(post);
    setForm({ content: post.content });
    setShowModal(true);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      if (editing) {
        await updatePost(editing._id, form);
      } else {
        await createPost({ ...form, userId: user?.email || 'anonymous' });
      }
      setShowModal(false);
      fetchData();
    } catch {
      /* ignore */
    }
  };

  const handleDelete = async (id) => {
    if (!window.confirm('Delete this post?')) return;
    try {
      await deletePost(id);
      fetchData();
    } catch {
      /* ignore */
    }
  };

  return (
    <>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <h1>Posts</h1>
        <button className="btn btn-primary" onClick={openCreate}>+ New Post</button>
      </div>

      <div className="card" style={{ marginTop: '1rem' }}>
        <table>
          <thead>
            <tr>
              <th>Content</th>
              <th>User</th>
              <th>Likes</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            {posts.map((p) => (
              <tr key={p._id}>
                <td>{p.content}</td>
                <td>{p.userId}</td>
                <td>{p.likes ?? 0}</td>
                <td className="action-btns">
                  <button className="btn btn-sm btn-primary" onClick={() => openEdit(p)}>Edit</button>
                  <button className="btn btn-sm btn-danger" onClick={() => handleDelete(p._id)}>Delete</button>
                </td>
              </tr>
            ))}
            {posts.length === 0 && (
              <tr><td colSpan={4} style={{ textAlign: 'center', padding: '2rem' }}>No posts yet.</td></tr>
            )}
          </tbody>
        </table>
      </div>

      {showModal && (
        <div className="modal-backdrop" onClick={() => setShowModal(false)}>
          <div className="modal" onClick={(e) => e.stopPropagation()}>
            <h2>{editing ? 'Edit Post' : 'Create Post'}</h2>
            <form onSubmit={handleSubmit}>
              <div className="form-group">
                <label>Content</label>
                <textarea
                  rows={4}
                  required
                  value={form.content}
                  onChange={(e) => setForm({ ...form, content: e.target.value })}
                />
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
