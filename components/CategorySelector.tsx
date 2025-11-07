import React from 'react';
import type { Category } from '../types';
import { AppLogoIcon, PlayIcon } from './icons';

interface CategorySelectorProps {
  categories: Category[];
  onSelectCategory: (category: Category) => void;
}

const CategorySelector: React.FC<CategorySelectorProps> = ({ categories, onSelectCategory }) => {
    const getBadge = (categoryId: string) => {
        switch (categoryId) {
            case 'organizational':
                return <span className="bg-orange-900/20 text-[#D4A017] text-xs font-semibold px-2.5 py-0.5 rounded-full border border-[#D4A017]/50">3 нових</span>;
            case 'hunt_drive':
                 return <span className="bg-lime-900/20 text-yellow-400 text-xs font-semibold px-2.5 py-0.5 rounded-full border border-yellow-400/50">популярне</span>;
            default:
                return null;
        }
    };

  return (
    <div className="max-w-xl mx-auto text-center">
      <div className="flex flex-col items-center mb-8 text-[#f5f0e1]">
        <AppLogoIcon />
        <h1 className="font-cinzel text-2xl font-bold mt-2">Лісові сурми</h1>
        <p className="text-sm text-[#f5f0e1]/70 mt-1">Поліський фаховий коледж лісового господарства та технологій</p>
        <p className="text-base text-[#f5f0e1]/80 mt-4 max-w-md">
          Додаток для прослуховування аудіо та перегляд відео на тематику мисливської сигнальної музики. Обирайте категорію, слухайте сигнали, дивіться відео та дізнавайтесь більше.
        </p>
      </div>
      
      <div className="bg-[#f5f0e1] rounded-2xl p-4 mb-10 shadow-lg text-[#2a1a0e] border-2 border-[#D4A017]/50" style={{boxShadow: 'inset 0 0 10px rgba(0,0,0,0.2)'}}>
        <h2 className="text-xl font-bold font-cinzel text-[#2a1a0e]/80 mb-4">Сигнал дня</h2>
        <div className="flex items-center gap-4 text-left">
            <div className="flex-shrink-0">
                <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ7y28UbG2l5eG222p05GFWd2nJpY3y9Yd3qw&s" alt="House" className="w-16 h-16 object-cover rounded-lg border-2 border-[#D4A017]/30"/>
            </div>
            <div>
                <h3 className="text-xl font-bold font-cinzel">На лови • 12:00</h3>
                <p className="text-sm mt-1 text-[#2a1a0e]/80">Сигнал звучить, коли для початку ловів все готово — заклик рушати</p>
            </div>
        </div>
        <button className="mt-4 w-full bg-[#D4A017] text-white font-bold py-2.5 px-4 rounded-xl flex items-center justify-center transition-transform hover:scale-105 shadow-md border border-amber-300/50">
          <PlayIcon />
          <span>Відтворити</span>
        </button>
      </div>
      
      <div className="space-y-4">
        {categories.map((category) => (
          <button
            key={category.id}
            onClick={() => onSelectCategory(category)}
            className="w-full bg-[#f5f0e1] rounded-2xl p-4 flex items-center justify-between shadow-md transition-transform hover:scale-105 text-left border-2 border-[#D4A017]/50 hover:border-[#D4A017] text-[#2a1a0e]"
            style={{boxShadow: 'inset 0 0 10px rgba(0,0,0,0.1)'}}
          >
            <div className="flex items-center gap-4">
              <div className="text-[#D4A017]">
                {category.icon}
              </div>
              <div>
                <h3 className="text-lg font-bold font-cinzel">
                  {category.name}
                </h3>
                <p className="text-sm text-[#2a1a0e]/70">Сигнали для {category.name.toLowerCase()}</p>
              </div>
            </div>
            <div className="flex items-center gap-2">
              {getBadge(category.id)}
              <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5 text-[#2a1a0e]/30" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
              </svg>
            </div>
          </button>
        ))}
      </div>
    </div>
  );
};

export default CategorySelector;