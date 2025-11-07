import React, { useState, useEffect } from 'react';
import type { Signal } from '../types';
import { AudioIcon, VideoIcon, InfoIcon, Spinner, EditIcon, GalleryIcon, ManageGalleryIcon } from './icons';
import { getSoundCloudEmbedUrl } from '../utils';

interface SignalDetailProps {
  signal: Signal | null;
  isLoggedIn: boolean;
  onEditSignal: (signal: Signal) => void;
  onManageGallery: (signal: Signal) => void;
}

const SignalDetail: React.FC<SignalDetailProps> = ({ signal, isLoggedIn, onEditSignal, onManageGallery }) => {
  const [activeTab, setActiveTab] = useState<'info' | 'audio' | 'video' | 'gallery'>('info');
  const [isVideoLoading, setIsVideoLoading] = useState(true);
  const [isAudioLoading, setIsAudioLoading] = useState(true);

  useEffect(() => {
    // When a new signal is selected, reset loading states for both players.
    if (signal) {
      setIsVideoLoading(true);
      setIsAudioLoading(true);
    }
  }, [signal]);

  if (!signal) {
    return (
      <div className="flex items-center justify-center h-full bg-[#f5f0e1] rounded-2xl p-8 shadow-lg border-2 border-[#D4A017]/50 text-[#2a1a0e]">
        <p className="text-[#2a1a0e]/70 text-xl">Оберіть сигнал зі списку для перегляду деталей.</p>
      </div>
    );
  }

  const tabButtonStyle = "flex items-center px-4 py-2 text-sm font-medium rounded-t-lg transition-colors border-b-2";
  const activeTabStyle = "border-[#D4A017] text-[#2a1a0e] font-bold";
  const inactiveTabStyle = "border-transparent text-[#2a1a0e]/60 hover:border-[#D4A017]/50 hover:text-[#2a1a0e]";

  return (
    <div className="bg-[#f5f0e1] rounded-2xl h-full shadow-lg border-2 border-[#D4A017]/50 text-[#2a1a0e]" style={{boxShadow: 'inset 0 0 10px rgba(0,0,0,0.2)'}}>
      <div className="px-6 pt-6">
        <div className="flex justify-between items-start">
            <h2 className="text-3xl font-bold font-cinzel flex-grow">{signal.title}</h2>
            {isLoggedIn && (
                <div className="ml-4 flex-shrink-0 flex items-center gap-2">
                    <button 
                        onClick={() => onManageGallery(signal)}
                        className="p-2 rounded-full bg-[#2a1a0e]/10 hover:bg-[#D4A017] text-[#2a1a0e] hover:text-white transition-colors"
                        aria-label="Керувати галереєю"
                    >
                        <ManageGalleryIcon />
                    </button>
                    <button 
                        onClick={() => onEditSignal(signal)}
                        className="p-2 rounded-full bg-[#2a1a0e]/10 hover:bg-[#D4A017] text-[#2a1a0e] hover:text-white transition-colors"
                        aria-label="Редагувати сигнал"
                    >
                        <EditIcon />
                    </button>
                </div>
            )}
        </div>
      </div>
      <div className="border-b border-[#2a1a0e]/20 px-6 mt-4">
        <nav className="-mb-px flex space-x-2" aria-label="Tabs">
          <button onClick={() => setActiveTab('info')} className={`${tabButtonStyle} ${activeTab === 'info' ? activeTabStyle : inactiveTabStyle}`}>
            <InfoIcon /> Інформація
          </button>
          <button onClick={() => setActiveTab('audio')} className={`${tabButtonStyle} ${activeTab === 'audio' ? activeTabStyle : inactiveTabStyle}`}>
            <AudioIcon /> Аудіо
          </button>
          <button onClick={() => setActiveTab('video')} className={`${tabButtonStyle} ${activeTab === 'video' ? activeTabStyle : inactiveTabStyle}`}>
            <VideoIcon /> Відео
          </button>
          {signal.gallery && signal.gallery.length > 0 && (
            <button onClick={() => setActiveTab('gallery')} className={`${tabButtonStyle} ${activeTab === 'gallery' ? activeTabStyle : inactiveTabStyle}`}>
              <GalleryIcon /> Галерея
            </button>
          )}
        </nav>
      </div>
      <div className="p-6">
        {activeTab === 'info' && (
          <div className="text-[#2a1a0e]/90 leading-relaxed text-base min-h-[300px]">
            <p>{signal.description}</p>
          </div>
        )}
        {activeTab === 'audio' && (
          <div className="min-h-[300px]">
            <h3 className="text-lg font-semibold mb-4 font-cinzel">Прослухати сигнал</h3>
            <div className="relative bg-black rounded-lg overflow-hidden border border-[#2a1a0e]/20">
              {isAudioLoading && (
                <div className="absolute inset-0 flex flex-col items-center justify-center bg-[#2a1a0e]/50">
                    <Spinner />
                    <p className="mt-2 text-white">Завантаження аудіо...</p>
                </div>
              )}
              <iframe
                key={signal.id}
                width="100%"
                height="300"
                scrolling="no"
                frameBorder="no"
                allow="autoplay"
                src={getSoundCloudEmbedUrl(signal.audioUrl)}
                onLoad={() => setIsAudioLoading(false)}
                className={`w-full ${isAudioLoading ? 'opacity-0' : 'opacity-100 transition-opacity'}`}
              ></iframe>
            </div>
          </div>
        )}
        {activeTab === 'video' && (
          <div className="min-h-[300px]">
            <h3 className="text-lg font-semibold mb-4 font-cinzel">Переглянути відео</h3>
            <div className="relative bg-black rounded-lg overflow-hidden border border-[#2a1a0e]/20" style={{ paddingTop: '56.25%' }}>
              {isVideoLoading && (
                <div className="absolute inset-0 flex flex-col items-center justify-center bg-[#2a1a0e]/50">
                    <Spinner />
                    <p className="mt-2 text-white">Завантаження відео...</p>
                </div>
              )}
              <iframe
                key={signal.id}
                src={signal.videoUrl}
                title={signal.title}
                frameBorder="0"
                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                allowFullScreen
                onLoad={() => setIsVideoLoading(false)}
                className={`w-full h-full absolute inset-0 ${isVideoLoading ? 'opacity-0' : 'opacity-100 transition-opacity'}`}
              ></iframe>
            </div>
          </div>
        )}
        {activeTab === 'gallery' && (
          <div className="min-h-[300px]">
            <h3 className="text-lg font-semibold mb-4 font-cinzel">Галерея</h3>
            <div className="grid grid-cols-2 sm:grid-cols-3 gap-4">
              {signal.gallery?.map((url, index) => (
                <a key={`${url}-${index}`} href={url} target="_blank" rel="noopener noreferrer" className="block group relative w-full pt-[100%] bg-[#2a1a0e]/10 rounded-lg overflow-hidden">
                  <img 
                    src={url} 
                    alt={`Gallery image ${index + 1}`} 
                    className="absolute inset-0 w-full h-full object-cover border-2 border-transparent group-hover:border-[#D4A017] transition"
                  />
                </a>
              ))}
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default SignalDetail;