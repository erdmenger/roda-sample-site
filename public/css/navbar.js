(function($)  { // Begin jQuery
    $(function() { // DOM ready
      // Toggle open and close nav styles on click
      $('#nav-toggle').click(function() {
        $('nav ul').slideToggle();
      });
      // Hamburger to X toggle
      document.querySelector('#nav-toggle').addEventListener('click', function() {
        this.classList.toggle('active');
      });
    }); // end DOM ready
})(jQuery); // end jQuery


