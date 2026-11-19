// Dymmer Blog - Client scripts
// Checks if the user is currently logged in to Dymmer via shared root-domain cookie.
(function () {
  function checkAuth() {
    var hasSession = document.cookie
      .split(';')
      .some(function (item) {
        return item.trim().indexOf('dymmer_logged_in=true') === 0;
      });

    if (hasSession) {
      document.documentElement.classList.add('user-logged-in');
    } else {
      document.documentElement.classList.remove('user-logged-in');
    }
  }

  // Run on initial load
  checkAuth();

  // Re-check when window regains focus or visibility (e.g. user logged in or out in another tab)
  if (typeof window !== 'undefined') {
    window.addEventListener('focus', checkAuth);
    document.addEventListener('visibilitychange', function () {
      if (document.visibilityState === 'visible') {
        checkAuth();
      }
    });
  }
})();
