import React, { useState } from 'react';

interface LoginModalProps {
  onClose: () => void;
  onLogin: (success: boolean, message?: string) => void;
}

const LoginModal: React.FC<LoginModalProps> = ({ onClose, onLogin }) => {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');

  const handleLoginAttempt = (e: React.FormEvent) => {
    e.preventDefault();
    if (username === 'admin' && password === 'admin') {
      setError('');
      onLogin(true);
    } else {
      setError('Неправильний логін або пароль.');
      onLogin(false, 'Invalid credentials');
    }
  };

  return (
    <div 
      className="fixed inset-0 bg-black bg-opacity-75 flex items-center justify-center z-50 p-4"
      onClick={onClose}
    >
      <div 
        className="bg-[#f5f0e1] border-2 border-[#D4A017]/50 rounded-2xl shadow-xl p-8 w-full max-w-sm text-[#2a1a0e]"
        onClick={(e) => e.stopPropagation()}
        style={{boxShadow: 'inset 0 0 10px rgba(0,0,0,0.2)'}}
      >
        <h2 className="text-2xl font-bold text-center font-cinzel text-[#2a1a0e] mb-6">Вхід для адміністратора</h2>
        <form onSubmit={handleLoginAttempt}>
          <div className="mb-4">
            <label className="block text-[#2a1a0e]/80 text-sm font-bold mb-2" htmlFor="username">
              Логін
            </label>
            <input
              type="text"
              id="username"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
              className="shadow-inner appearance-none border border-[#2a1a0e]/20 rounded-lg w-full py-2 px-3 bg-white/70 text-[#2a1a0e] leading-tight focus:outline-none focus:ring-2 focus:ring-[#D4A017]"
              required
            />
          </div>
          <div className="mb-6">
            <label className="block text-[#2a1a0e]/80 text-sm font-bold mb-2" htmlFor="password">
              Пароль
            </label>
            <input
              type="password"
              id="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              className="shadow-inner appearance-none border border-[#2a1a0e]/20 rounded-lg w-full py-2 px-3 bg-white/70 text-[#2a1a0e] mb-3 leading-tight focus:outline-none focus:ring-2 focus:ring-[#D4A017]"
              required
            />
          </div>
          {error && <p className="text-red-500 text-xs italic mb-4">{error}</p>}
          <div className="flex items-center justify-between">
            <button
              type="submit"
              className="bg-[#D4A017] hover:bg-amber-500 text-white font-bold py-2 px-4 rounded-lg focus:outline-none focus:shadow-outline transition-colors"
            >
              Увійти
            </button>
            <button
              type="button"
              onClick={onClose}
              className="inline-block align-baseline font-bold text-sm text-[#2a1a0e]/60 hover:text-[#2a1a0e]"
            >
              Скасувати
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default LoginModal;