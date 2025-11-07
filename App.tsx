import React, { useState } from 'react';
import type { Category, Signal } from './types';
import { CATEGORIES as initialCategories } from './constants';
import CategorySelector from './components/CategorySelector';
import SignalList from './components/SignalList';
import SignalDetail from './components/SignalDetail';
import LoginModal from './components/LoginModal';
import AddSignalModal from './components/AddSignalModal';
import EditSignalModal from './components/EditSignalModal';
import ManageGalleryModal from './components/ManageGalleryModal';
import { BackIcon, PlusIcon } from './components/icons';

function App() {
  const [categories, setCategories] = useState<Category[]>(initialCategories);
  const [selectedCategory, setSelectedCategory] = useState<Category | null>(null);
  const [selectedSignal, setSelectedSignal] = useState<Signal | null>(null);
  
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [showLoginModal, setShowLoginModal] = useState(false);
  const [showAddSignalModal, setShowAddSignalModal] = useState(false);
  const [editingSignal, setEditingSignal] = useState<Signal | null>(null);
  const [managingGallerySignal, setManagingGallerySignal] = useState<Signal | null>(null);


  const handleSelectCategory = (category: Category) => {
    setSelectedCategory(category);
    setSelectedSignal(category.signals[0] || null);
  };

  const handleBackToCategories = () => {
    setSelectedCategory(null);
    setSelectedSignal(null);
  };

  const handleLogin = (success: boolean) => {
    if (success) {
      setIsLoggedIn(true);
      setShowLoginModal(false);
    }
  };
  
  const handleLogout = () => {
    setIsLoggedIn(false);
  };

  const handleAddSignal = (newSignalData: Omit<Signal, 'id'>) => {
    if (!selectedCategory) return;
    
    const newSignal: Signal = {
      ...newSignalData,
      id: `custom-${Date.now()}`
    };

    const updatedCategories = categories.map(category => {
      if (category.id === selectedCategory.id) {
        return {
          ...category,
          signals: [...category.signals, newSignal]
        };
      }
      return category;
    });
    setCategories(updatedCategories);

    // Also update the selected category in state to reflect the change immediately
    const updatedSelectedCategory = updatedCategories.find(c => c.id === selectedCategory.id);
    if(updatedSelectedCategory) {
       setSelectedCategory(updatedSelectedCategory);
    }

    setShowAddSignalModal(false);
  };

  const handleSaveSignal = (updatedSignal: Signal) => {
    const updatedCategories = categories.map(category => ({
      ...category,
      signals: category.signals.map(signal =>
        signal.id === updatedSignal.id ? updatedSignal : signal
      )
    }));
    setCategories(updatedCategories);

    if (selectedCategory) {
      const updatedSelectedCategory = updatedCategories.find(c => c.id === selectedCategory.id);
      if (updatedSelectedCategory) {
        setSelectedCategory(updatedSelectedCategory);
      }
    }
    if (selectedSignal && selectedSignal.id === updatedSignal.id) {
      setSelectedSignal(updatedSignal);
    }
    setEditingSignal(null);
    setManagingGallerySignal(null);
  };

  return (
    <div className="min-h-screen text-[#f5f0e1] p-4 sm:p-6 md:p-8">
      {showLoginModal && <LoginModal onClose={() => setShowLoginModal(false)} onLogin={handleLogin} />}
      {showAddSignalModal && selectedCategory && (
        <AddSignalModal 
          categoryName={selectedCategory.name}
          onClose={() => setShowAddSignalModal(false)}
          onAddSignal={handleAddSignal}
        />
      )}
      {editingSignal && selectedCategory && (
        <EditSignalModal
          signal={editingSignal}
          categoryName={selectedCategory.name}
          onClose={() => setEditingSignal(null)}
          onSave={handleSaveSignal}
        />
      )}
      {managingGallerySignal && (
        <ManageGalleryModal
          signal={managingGallerySignal}
          onClose={() => setManagingGallerySignal(null)}
          onSave={handleSaveSignal}
        />
      )}

      <main className="max-w-7xl mx-auto pb-32">
        {!selectedCategory ? (
          <CategorySelector
            categories={categories}
            onSelectCategory={handleSelectCategory}
          />
        ) : (
          <div>
            <div className="flex justify-between items-center mb-6">
              <button
                onClick={handleBackToCategories}
                className="flex items-center gap-2 text-[#f5f0e1] hover:text-[#D4A017] transition-colors text-lg"
              >
                <BackIcon />
                <span>До категорій</span>
              </button>
              {isLoggedIn && (
                 <button
                    onClick={() => setShowAddSignalModal(true)}
                    className="flex items-center gap-2 bg-[#D4A017] hover:bg-amber-500 text-white font-bold py-2 px-4 rounded-lg transition-colors shadow-md"
                  >
                    <PlusIcon />
                    <span>Додати сигнал</span>
                  </button>
              )}
            </div>
            <div className="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-4 gap-8">
              <div className="md:col-span-1 lg:col-span-1">
                <SignalList
                  category={selectedCategory}
                  selectedSignal={selectedSignal}
                  onSelectSignal={setSelectedSignal}
                />
              </div>
              <div className="md:col-span-2 lg:col-span-3">
                <SignalDetail
                  signal={selectedSignal}
                  isLoggedIn={isLoggedIn}
                  onEditSignal={setEditingSignal}
                  onManageGallery={setManagingGallerySignal}
                />
              </div>
            </div>
          </div>
        )}
      </main>
      
      <footer className="fixed bottom-0 left-0 right-0 bg-[#2a1a0e] bg-opacity-90 backdrop-blur-sm shadow-[0_-2px_10px_rgba(0,0,0,0.2)] p-3 z-10">
          <div className="max-w-7xl mx-auto flex justify-center items-center gap-4">
              {!isLoggedIn ? (
                  <button onClick={() => setShowLoginModal(true)} className="bg-transparent text-[#f5f0e1] font-bold py-3 px-8 rounded-full border-2 border-[#D4A017] transition-colors hover:bg-[#D4A017] hover:text-[#2a1a0e]">
                      Адміністрування
                  </button>
              ) : (
                  <button onClick={handleLogout} className="bg-transparent text-red-400 font-bold py-3 px-8 rounded-full border-2 border-red-500 transition-colors hover:bg-red-500 hover:text-white">
                      Вийти
                  </button>
              )}
          </div>
          <p className="text-center text-xs text-[#f5f0e1]/50 mt-2">Розроблено студентами та викладачами Поліського фахового коледжу лісового господарства та технологій</p>
      </footer>
    </div>
  );
}

export default App;