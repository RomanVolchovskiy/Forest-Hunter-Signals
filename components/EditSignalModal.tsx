import React, { useState, useEffect } from 'react';
import type { Signal } from '../types';

interface EditSignalModalProps {
  signal: Signal;
  categoryName: string;
  onClose: () => void;
  onSave: (signal: Signal) => void;
}

const EditSignalModal: React.FC<EditSignalModalProps> = ({ signal, categoryName, onClose, onSave }) => {
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [audioUrl, setAudioUrl] = useState('');
  const [videoUrl, setVideoUrl] = useState('');
  const [error, setError] = useState('');

  useEffect(() => {
    if (signal) {
      setTitle(signal.title);
      setDescription(signal.description);
      setAudioUrl(signal.audioUrl);
      setVideoUrl(signal.videoUrl);
    }
  }, [signal]);
  
  const handleInputChange = <T,>(setter: React.Dispatch<React.SetStateAction<T>>) => (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    setError('');
    setter(e.target.value as T);
  };
  
  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    if (!title || !description || !audioUrl || !videoUrl) {
      setError('Будь ласка, заповніть усі поля.');
      return;
    }

    // No longer converting URL. Trusting user to input the correct embed URL.
    onSave({
      ...signal,
      title,
      description,
      audioUrl,
      videoUrl: videoUrl,
    });
    onClose();
  };

  return (
    <div 
      className="fixed inset-0 bg-black bg-opacity-75 flex items-center justify-center z-50 overflow-y-auto p-4"
      onClick={onClose}
    >
      <div 
        className="bg-[#f5f0e1] border-2 border-[#D4A017]/50 rounded-2xl shadow-xl p-8 w-full max-w-2xl max-h-full overflow-y-auto text-[#2a1a0e]"
        onClick={(e) => e.stopPropagation()}
        style={{boxShadow: 'inset 0 0 10px rgba(0,0,0,0.2)'}}
      >
        <h2 className="text-2xl font-bold text-[#2a1a0e] mb-2 font-cinzel">Редагувати сигнал</h2>
        <p className="text-[#2a1a0e]/80 mb-6">Категорія: <span className="font-semibold">{categoryName}</span></p>
        <form onSubmit={handleSubmit} className="space-y-4">
          <div>
            <label className="block text-[#2a1a0e]/80 text-sm font-bold mb-2" htmlFor="edit-title">Назва сигналу</label>
            <input type="text" id="edit-title" value={title} onChange={handleInputChange(setTitle)} className="shadow-inner appearance-none border border-[#2a1a0e]/20 rounded-lg w-full py-2 px-3 bg-white/70 text-[#2a1a0e] leading-tight focus:outline-none focus:ring-2 focus:ring-[#D4A017]" required />
          </div>
          <div>
            <label className="block text-[#2a1a0e]/80 text-sm font-bold mb-2" htmlFor="edit-description">Опис</label>
            <textarea id="edit-description" value={description} onChange={handleInputChange(setDescription)} rows={4} className="shadow-inner appearance-none border border-[#2a1a0e]/20 rounded-lg w-full py-2 px-3 bg-white/70 text-[#2a1a0e] leading-tight focus:outline-none focus:ring-2 focus:ring-[#D4A017]" required />
          </div>
          <div>
            <label className="block text-[#2a1a0e]/80 text-sm font-bold mb-2" htmlFor="edit-audioUrl">URL аудіо (з SoundCloud)</label>
            <input type="url" id="edit-audioUrl" value={audioUrl} onChange={handleInputChange(setAudioUrl)} className="shadow-inner appearance-none border border-[#2a1a0e]/20 rounded-lg w-full py-2 px-3 bg-white/70 text-[#2a1a0e] leading-tight focus:outline-none focus:ring-2 focus:ring-[#D4A017]" required />
          </div>
          <div>
            <label className="block text-[#2a1a0e]/80 text-sm font-bold mb-2" htmlFor="edit-videoUrl">URL для вбудовування відео (з Vimeo/YouTube)</label>
            <input type="url" id="edit-videoUrl" value={videoUrl} onChange={handleInputChange(setVideoUrl)} className="shadow-inner appearance-none border border-[#2a1a0e]/20 rounded-lg w-full py-2 px-3 bg-white/70 text-[#2a1a0e] leading-tight focus:outline-none focus:ring-2 focus:ring-[#D4A017]" required />
          </div>
          
          {error && <p className="text-red-500 text-sm text-center">{error}</p>}

          <div className="flex items-center justify-end pt-4 gap-4">
            <button type="button" onClick={onClose} className="inline-block align-baseline font-bold text-sm text-[#2a1a0e]/60 hover:text-[#2a1a0e]">Скасувати</button>
            <button type="submit" className="bg-[#D4A017] hover:bg-amber-500 text-white font-bold py-2 px-4 rounded-lg focus:outline-none focus:shadow-outline transition-colors">Зберегти зміни</button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default EditSignalModal;