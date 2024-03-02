class SupabaseCred {
  String anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpmZWZpc3Jlc2dqaGV2dG15cGJ0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDkxNDE5NDcsImV4cCI6MjAyNDcxNzk0N30.l1e-Cy3_cZ0q_lA8IZTvrP1obGAf7DxWi4SrL_dUsBQ';
  String url = 'https://jfefisresgjhevtmypbt.supabase.co';
  String getAnon() {
    return anonKey;
  }

  String getUrl() {
    return url;
  }
}
