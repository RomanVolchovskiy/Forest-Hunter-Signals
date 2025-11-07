import React from 'react';
import type { Category, Signal } from '../types';

interface SignalListProps {
  category: Category;
  selectedSignal: Signal | null;
  onSelectSignal: (signal: Signal) => void;
}

const SignalList: React.FC<SignalListProps> = ({ category, selectedSignal, onSelectSignal }) => {
  return (
    <div className="bg-[#f5f0e1] rounded-2xl p-4 h-full shadow-lg border-2 border-[#D4A017]/50 text-[#2a1a0e]" style={{boxShadow: 'inset 0 0 10px rgba(0,0,0,0.2)'}}>
      <h3 className="text-2xl font-bold mb-4 px-2 font-cinzel">{category.name}</h3>
      <ul className="space-y-2">
        {category.signals.map((signal) => (
          <li key={signal.id}>
            <button
              onClick={() => onSelectSignal(signal)}
              className={`w-full text-left px-4 py-3 rounded-xl transition-all duration-200 font-medium ${
                selectedSignal?.id === signal.id
                  ? 'bg-[#D4A017] text-white font-semibold shadow-md'
                  : 'bg-transparent text-[#2a1a0e] hover:bg-[#D4A017]/20 hover:pl-6'
              }`}
            >
              {signal.title}
            </button>
          </li>
        ))}
      </ul>
    </div>
  );
};

export default SignalList;