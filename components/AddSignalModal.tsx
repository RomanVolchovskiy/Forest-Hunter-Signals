import React, { useState } from 'react';
import type { Signal } from '../types';

interface AddSignalModalProps {
  categoryName: string;
  onClose: () => void;
  onAddSignal: (signal: Omit<Signal, 'id'>) => void;
}

const AddSignalModal: React.FC<AddSignalModalProps> = ({ categoryName, onClose, onAddSignal }) => {
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [audioUrl, setAudioUrl] = useState('');
  const [videoUrl, setVideoUrl] = useState('');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!title || !description || !audioUrl || !videoUrl) {
      alert('Будь ласка, заповніть усі поля.');
      return;
    }
    // No longer converting URL. Trusting user to input the correct embed URL.
    onAddSignal({ title, description, audioUrl, videoUrl: videoUrl, gallery: [] });
  };

  return (
    <div 
      className="fixed inset-0 bg-black bg-opacity-75 flex items-center justify-center z-50 p-4"
      onClick={onClose}
    >
      <div 
        className="bg-[#f5f0e1] border-2 border-[#D4A017]/50 rounded-2xl shadow-xl p-8 w-full max-w-lg text-[#2a1a0e]"
        onClick={(e) => e.stopPropagation()}
        style={{boxShadow: 'inset 0 0 10px rgba(0,0,0,0.2)'}}
      >
        <h2 className="text-2xl font-bold text-[#2a1a0e] mb-2 font-cinzel">Додати новий сигнал</h2>
        <p className="text-[#2a1a0e]/80 mb-6">Додавання до категорії: <span className="font-semibold">{categoryName}</span></p>
        <form onSubmit={handleSubmit} className="space-y-4">
          <div>
            <label className="block text-[#2a1a0e]/80 text-sm font-bold mb-2" htmlFor="title">
              Назва сигналу
            </label>
            <input
              type="text"
              id="title"
              value={title}
              onChange={(e) => setTitle(e.target.value)}
              className="shadow-inner appearance-none border border-[#2a1a0e]/20 rounded-lg w-full py-2 px-3 bg-white/70 text-[#2a1a0e] leading-tight focus:outline-none focus:ring-2 focus:ring-[#D4A017]"
              required
            />
          </div>
          <div>
            <label className="block text-[#2a1a0e]/80 text-sm font-bold mb-2" htmlFor="description">
              Опис
            </label>
            <textarea
              id="description"
              value={description}
              onChange={(e) => setDescription(e.target.value)}
              rows={4}
              className="shadow-inner appearance-none border border-[#2a1a0e]/20 rounded-lg w-full py-2 px-3 bg-white/70 text-[#2a1a0e] leading-tight focus:outline-none focus:ring-2 focus:ring-[#D4A017]"
              required
            />
          </div>
          <div>
            <label className="block text-[#2a1a0e]/80 text-sm font-bold mb-2" htmlFor="audioUrl">
              URL аудіо (з SoundCloud)
            </label>
            <input
              type="url"
              id="audioUrl"
              value={audioUrl}
              onChange={(e) => setAudioUrl(e.target.value)}
              className="shadow-inner appearance-none border border-[#2a1a0e]/20 rounded-lg w-full py-2 px-3 bg-white/70 text-[#2a1a0e] leading-tight focus:outline-none focus:ring-2 focus:ring-[#D4A017]"
              required
            />
          </div>
          <div>
            <label className="block text-[#2a1a0e]/80 text-sm font-bold mb-2" htmlFor="videoUrl">
              URL для вбудовування відео (з Vimeo/YouTube)
            </label>
            <input
              type="url"
              id="videoUrl"
              value={videoUrl}
              onChange={(e) => setVideoUrl(e.target.value)}
              className="shadow-inner appearance-none border border-[#2a1a0e]/20 rounded-lg w-full py-2 px-3 bg-white/70 text-[#2a1a0e] leading-tight focus:outline-none focus:ring-2 focus:ring-[#D4A017]"
              required
            />
          </div>
          <div className="flex items-center justify-end pt-4 gap-4">
            <button
              type="button"
              onClick={onClose}
              className="inline-block align-baseline font-bold text-sm text-[#2a1a0e]/60 hover:text-[#2a1a0e]"
            >
              Скасувати
            </button>
            <button
              type="submit"
              className="bg-[#D4A017] hover:bg-amber-500 text-white font-bold py-2 px-4 rounded-lg focus:outline-none focus:shadow-outline transition-colors"
            >
              Додати сигнал
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default AddSignalModal;