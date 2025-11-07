/**
 * Converts a SoundCloud track URL to a standard embeddable player URL.
 * @param trackUrl The original SoundCloud track URL.
 * @returns A URL suitable for the SoundCloud iframe player.
 */
export function getSoundCloudEmbedUrl(trackUrl: string): string {
  if (!trackUrl || !trackUrl.includes('soundcloud.com')) return '';
  const encodedUrl = encodeURIComponent(trackUrl);
  // Using a consistent color scheme and disabling auto-play for better user experience.
  return `https://w.soundcloud.com/player/?url=${encodedUrl}&color=%23D4A017&auto_play=false&hide_related=true&show_comments=false&show_user=true&show_reposts=false&show_teaser=true&visual=true`;
}
