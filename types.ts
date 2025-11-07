// FIX: Import React to make the `React` namespace available for `React.ReactNode`.
import React from 'react';

export interface Signal {
  id: string;
  title: string;
  description: string;
  audioUrl: string;
  videoUrl: string;
  gallery: string[];
}

export interface Category {
  id: string;
  name: string;
  icon: React.ReactNode;
  signals: Signal[];
}