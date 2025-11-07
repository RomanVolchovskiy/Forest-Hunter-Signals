import React, { useState, useEffect } from 'react';
import type { Signal } from '../types';
import { TrashIcon } from './icons';

interface ManageGalleryModalProps {
  signal: Signal;
  onClose: () => void;
  onSave: (signal: Signal) => void;
}

const ManageGalleryModal: React.FC<ManageGalleryModalProps> = ({ signal, onClose, onSave }) => {
  const [gallery, setGallery] = useState<string[]>([]);
  const [newImageUrl, setNewImageUrl] = useState('');
  const [error, setError] = useState('');

  useEffect(() => {
    if (signal) {
      setGallery(signal.gallery || []);
    }
  }, [signal]);

  const handleAddImage = () => {
    const trimmedUrl = newImageUrl.trim();
    setError('');

    if (!trimmedUrl) {
      setError('Поле URL зображення не може бути порожнім.');
      return;
    }

    try {
      new URL(trimmedUrl);
    } catch (_) {
      setError('Будь ласка, введіть дійсну URL-адресу.');
      return;
    }

    if (gallery.includes(trimmedUrl)) {
      setError('Це зображення вже є в галереї.');
      return;
    }

    setGallery(prevGallery => [...prevGallery, trimmedUrl]);
    setNewImageUrl('');
  };

  const handleRemoveImage = (urlToRemove: string) => {
    setGallery(gallery.filter(url => url !== urlToRemove));
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    onSave({
      ...signal,
      gallery,
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
        <h2 className="text-2xl font-bold text-[#2a1a0e] mb-2 font-cinzel">Керування галереєю</h2>
        <p className="text-[#2a1a0e]/80 mb-6">Сигнал: <span className="font-semibold">{signal.title}</span></p>
        
        <div className="space-y-4">
          <div>
            <label className="block text-[#2a1a0e]/80 text-sm font-bold mb-2" htmlFor="new-image-url">URL нового зображення</label>
            <div className="flex gap-2">
              <input
                type="url"
                id="new-image-url"
                value={newImageUrl}
                onChange={(e) => {
                  setNewImageUrl(e.target.value);
                  setError('');
                }}
                placeholder="https://example.com/image.jpg"
                className="flex-grow shadow-inner appearance-none border border-[#2a1a0e]/20 rounded-lg py-2 px-3 bg-white/70 text-[#2a1a0e] leading-tight focus:outline-none focus:ring-2 focus:ring-[#D4A017]"
              />
              <button
                type="button"
                onClick={handleAddImage}
                className="bg-[#2a1a0e]/80 hover:bg-[#2a1a0e] text-white font-bold py-2 px-4 rounded-lg transition-colors"
              >
                Додати
              </button>
            </div>
          </div>

          {gallery.length > 0 ? (
            <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-4">
              {gallery.map((url) => (
                <div key={url} className="relative group">
                  <img src={url} alt="Елемент галереї" className="w-full h-24 object-cover rounded-lg border border-[#2a1a0e]/10" />
                  <button
                    type="button"
                    onClick={() => handleRemoveImage(url)}
                    className="absolute top-1 right-1 bg-red-600/80 hover:bg-red-500 text-white p-1 rounded-full opacity-0 group-hover:opacity-100 transition-opacity"
                    aria-label="Видалити зображення"
                  >
                    <TrashIcon />
                  </button>
                </div>
              ))}
            </div>
          ) : (
             <p className="text-[#2a1a0e]/60 text-center py-4">Галерея порожня.</p>
          )}
        </div>

        {error && <p className="text-red-500 text-sm text-center mt-4">{error}</p>}

        <div className="flex items-center justify-end pt-6 gap-4 border-t border-[#2a1a0e]/20 mt-6">
          <button type="button" onClick={onClose} className="inline-block align-baseline font-bold text-sm text-[#2a1a0e]/60 hover:text-[#2a1a0e]">Скасувати</button>
          <button type="button" onClick={handleSubmit} className="bg-[#D4A017] hover:bg-amber-500 text-white font-bold py-2 px-4 rounded-lg focus:outline-none focus:shadow-outline transition-colors">Зберегти</button>
        </div>
      </div>
    </div>
  );
};

export default ManageGalleryModal;