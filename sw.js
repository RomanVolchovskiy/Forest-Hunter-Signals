const CACHE_NAME = 'hunting-signals-cache-v2';
const urlsToCache = [
  '.',
  './index.html',
  './index.tsx',
  './App.tsx',
  './components/AddSignalModal.tsx',
  './components/CategorySelector.tsx',
  './components/icons.tsx',
  './components/LoginModal.tsx',
  './components/SignalDetail.tsx',
  './components/SignalList.tsx',
  './constants.ts',
  './types.ts',
  './icon.svg',
  'https://cdn.tailwindcss.com',
  'https://fonts.googleapis.com/css2?family=Merriweather:wght@400;700&family=Roboto:wght@400;500&display=swap',
  "https://aistudiocdn.com/react-dom@^19.2.0/",
  "https://aistudiocdn.com/react@^19.2.0/",
  "https://aistudiocdn.com/react@^19.2.0"
];

self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => {
        console.log('Opened cache');
        // Use addAll with a new Request object to bypass cache for CDN resources during installation
        const cachePromises = urlsToCache.map(urlToCache => {
            const request = new Request(urlToCache, {cache: 'reload'});
            return cache.add(request);
        });
        return Promise.all(cachePromises);
      })
  );
});

self.addEventListener('fetch', event => {
  event.respondWith(
    caches.match(event.request)
      .then(response => {
        // Cache hit - return response
        if (response) {
          return response;
        }
        // Not in cache - fetch and cache
        return fetch(event.request).then(
          (response) => {
            // Check if we received a valid response
            if(!response || response.status !== 200 || response.type !== 'basic') {
              if (response.type === 'opaque') {
                 // For CDN resources, we can't see the status, so just cache it.
              } else {
                 return response;
              }
            }

            const responseToCache = response.clone();

            caches.open(CACHE_NAME)
              .then(cache => {
                cache.put(event.request, responseToCache);
              });

            return response;
          }
        );
      })
    );
});

self.addEventListener('activate', event => {
  const cacheWhitelist = [CACHE_NAME];
  event.waitUntil(
    caches.keys().then(cacheNames => {
      return Promise.all(
        cacheNames.map(cacheName => {
          if (cacheWhitelist.indexOf(cacheName) === -1) {
            return caches.delete(cacheName);
          }
        })
      );
    })
  );
});