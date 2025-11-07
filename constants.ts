import React from 'react';
import type { Category } from './types';
import { CeremonyIcon, FreestyleIcon, HuntIcon, OrganizationIcon } from './components/icons';

export const CATEGORIES: Category[] = [
  {
    id: 'organizational',
    name: 'Організаційні',
    // FIX: Replaced JSX with React.createElement to prevent TypeScript parsing errors in a .ts file.
    icon: React.createElement(OrganizationIcon),
    signals: [
      {
        id: 'org1',
        title: 'Збір',
        description: 'Сигнал "Збір" використовується для скликання всіх учасників полювання в одному місці. Це один з найважливіших сигналів, що забезпечує координацію та безпеку.',
        audioUrl: 'https://soundcloud.com/brian-holmes-10/hunting-horn-a-call-to-gather',
        videoUrl: 'https://player.vimeo.com/video/1084537',
        gallery: [],
      },
      {
        id: 'org2',
        title: 'Увага, слухати!',
        description: 'Сигнал "Увага, слухати!" подається перед важливим оголошенням або інструктажем. Він вимагає від мисливців припинити розмови та зосередитись на керівнику полювання.',
        audioUrl: 'https://soundcloud.com/brian-holmes-10/hunting-horn-a-call-to-gather',
        videoUrl: 'https://www.youtube.com/embed/5m--i_a9h58',
        gallery: [],
      },
      {
        id: 'org3',
        title: 'Початок полювання',
        description: 'Цей урочистий сигнал сповіщає про офіційний початок полювання. Він піднімає бойовий дух та створює особливу атмосферу.',
        audioUrl: 'https://soundcloud.com/brian-holmes-10/hunting-horn-a-call-to-gather',
        videoUrl: 'https://www.youtube.com/embed/5m--i_a9h58',
        gallery: [],
      },
    ],
  },
  {
    id: 'hunt_drive',
    name: 'Сигнали покоту',
    // FIX: Replaced JSX with React.createElement to prevent TypeScript parsing errors in a .ts file.
    icon: React.createElement(HuntIcon),
    signals: [
      {
        id: 'hd1',
        title: 'Початок покоту',
        description: 'Сигнал "Початок покоту" дає команду загоничам починати рух та гнати звіра в напрямку стрільців.',
        audioUrl: 'https://soundcloud.com/user-593623969/hunting-horn',
        videoUrl: 'https://www.youtube.com/embed/bB3Wn8BWY-4',
        gallery: [],
      },
      {
        id: 'hd2',
        title: 'Звір у покоті',
        description: 'Цей сигнал інформує стрільців про те, що звір піднятий і рухається в межах зони полювання.',
        audioUrl: 'https://soundcloud.com/user-593623969/hunting-horn',
        videoUrl: 'https://www.youtube.com/embed/bB3Wn8BWY-4',
        gallery: [],
      },
      {
        id: 'hd3',
        title: 'Кінець покоту',
        description: 'Сигнал "Кінець покоту" означає, що загоничі дійшли до лінії стрільців і гін завершено.',
        audioUrl: 'https://soundcloud.com/user-593623969/hunting-horn',
        videoUrl: 'https://www.youtube.com/embed/bB3Wn8BWY-4',
        gallery: [],
      },
    ],
  },
    {
    id: 'ceremonial',
    name: 'Святкові та урочисті',
    // FIX: Replaced JSX with React.createElement to prevent TypeScript parsing errors in a .ts file.
    icon: React.createElement(CeremonyIcon),
    signals: [
      {
        id: 'cer1',
        title: 'Вітання',
        description: 'Сигнал "Вітання" виконується на початку полювання для привітання гостей та учасників. Це знак поваги та гостинності.',
        audioUrl: 'https://soundcloud.com/mauricelafleuraudio/hunting-horn-fanfare',
        videoUrl: 'https://www.youtube.com/embed/qg1rY3aFq7I',
        gallery: [],
      },
      {
        id: 'cer2',
        title: 'Кінець полювання',
        description: 'Сигнал "Кінець полювання" оголошує про завершення всіх полювальних дій. Після нього зброя має бути розряджена.',
        audioUrl: 'https://soundcloud.com/mauricelafleuraudio/hunting-horn-fanfare',
        videoUrl: 'https://www.youtube.com/embed/qg1rY3aFq7I',
        gallery: [],
      },
    ],
  },
  {
    id: 'freestyle',
    name: 'Довільна програма',
    // FIX: Replaced JSX with React.createElement to prevent TypeScript parsing errors in a .ts file.
    icon: React.createElement(FreestyleIcon),
    signals: [
      {
        id: 'fs1',
        title: 'Мисливський марш',
        description: 'Популярна мелодія, що часто виконується на мисливських фестивалях та зборах. Не є офіційним сигналом, але є частиною культури.',
        audioUrl: 'https://soundcloud.com/adrian-von-arx/jagdhorn-march',
        videoUrl: 'https://www.youtube.com/embed/nUys6yT200Y',
        gallery: [],
      },
      {
        id: 'fs2',
        title: 'На честь Святого Губерта',
        description: 'Композиція, присвячена покровителю мисливців, Святому Губерту. Часто виконується під час урочистих заходів.',
        audioUrl: 'https://soundcloud.com/adrian-von-arx/jagdhorn-march',
        videoUrl: 'https://www.youtube.com/embed/nUys6yT200Y',
        gallery: [],
      },
    ],
  },
];