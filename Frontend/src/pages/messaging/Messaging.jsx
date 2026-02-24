import { useEffect, useState, useRef } from 'react';
import socket from '../../api/socket';
import { useAuth } from '../../context/AuthContext';

export default function Messaging() {
  const { user } = useAuth();
  const [messages, setMessages] = useState([]);
  const [text, setText] = useState('');
  const bottomRef = useRef(null);
  const senderName = user?.name || user?.email || 'Me';

  useEffect(() => {
    socket.connect();

    socket.on('receive_message', (msg) => {
      setMessages((prev) => [...prev, { ...msg, type: 'received' }]);
    });

    return () => {
      socket.off('receive_message');
      socket.disconnect();
    };
  }, []);

  useEffect(() => {
    bottomRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages]);

  const sendMessage = (e) => {
    e.preventDefault();
    if (!text.trim()) return;

    const payload = {
      sender: senderName,
      message: text.trim(),
      timestamp: new Date().toISOString(),
    };

    socket.emit('send_message', payload);
    setMessages((prev) => [...prev, { ...payload, type: 'sent' }]);
    setText('');
  };

  return (
    <>
      <h1>Messaging</h1>
      <div className="chat-container">
        <div className="chat-messages">
          {messages.length === 0 && (
            <p style={{ textAlign: 'center', color: '#999', marginTop: '2rem' }}>
              No messages yet. Start the conversation!
            </p>
          )}
          {messages.map((m, idx) => (
            <div key={idx} className={`chat-bubble ${m.type}`}>
              <div>{m.message}</div>
              <div className="meta">
                {m.sender} · {new Date(m.timestamp).toLocaleTimeString()}
              </div>
            </div>
          ))}
          <div ref={bottomRef} />
        </div>

        <form className="chat-input-bar" onSubmit={sendMessage}>
          <input
            placeholder="Type a message…"
            value={text}
            onChange={(e) => setText(e.target.value)}
          />
          <button type="submit">Send</button>
        </form>
      </div>
    </>
  );
}
