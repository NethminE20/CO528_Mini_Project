import { useEffect, useState } from 'react';
import { getAnalytics } from '../../api/services';

export default function Analytics() {
  const [data, setData] = useState(null);

  useEffect(() => {
    getAnalytics()
      .then((res) => setData(res.data))
      .catch(() => {});
  }, []);

  if (!data) {
    return (
      <div className="page">
        <h1>Analytics</h1>
        <p>Loading analytics…</p>
      </div>
    );
  }

  return (
    <>
      <h1>Analytics</h1>
      <div className="analytics-grid" style={{ marginTop: '1rem' }}>
        <div className="stat-card">
          <div className="stat-value">{data.totalPosts ?? 0}</div>
          <div className="stat-label">Total Posts</div>
        </div>
        <div className="stat-card">
          <div className="stat-value">{data.totalLikes ?? 0}</div>
          <div className="stat-label">Total Likes</div>
        </div>
      </div>
    </>
  );
}
