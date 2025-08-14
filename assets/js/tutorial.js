//------------------------------- BEGIN copy functionality --------------------------------//
// Handle the copy functionality
function copyCode(button) {
	// Find the <code> element inside the same <pre>
	var code = button.nextElementSibling;
	var range = document.createRange();
	range.selectNode(code);
	window.getSelection().removeAllRanges();
	window.getSelection().addRange(range);

	try {
		// Execute the copy command
		document.execCommand('copy');
		// Change the icon and text to indicate that it's copied
		changeButtonToCopied(button);
	} catch (err) {
		console.error('Failed to copy code', err);
	}

	// Deselect the text after copying
	window.getSelection().removeAllRanges();
}

// Handle the change copy button functionality
function changeButtonToCopied(button) {
	// Change the button icon to check icon
	button.innerHTML = '<i class="bi bi-check-lg"></i>';
	button.classList.add('copied');

	// Set the cursor to 'default' during the copied state
	button.style.cursor = 'default';

	// Disable further clicking on the button
	button.onclick = function() {};

	// Reset after 2 seconds
	setTimeout(function() {
		button.innerHTML = '<i class="bi bi-copy"></i>';
		button.classList.remove('copied');

		// Reset cursor to 'pointer'
		button.style.cursor = 'pointer';

		// Re-enable copying functionality
		button.onclick = function() { copyCode(button); };
	}, 2000);
}
//-------------------------------- END copy functionality ---------------------------------//


//----------------------- BEGIN toggle and save theme functionality -----------------------//
const html = document.documentElement;
const toggleLink = document.getElementById('themeToggleLink');
const icon = toggleLink.querySelector('i');
const prismLight = document.getElementById("prism-light");
const prismNord = document.getElementById("prism-nord");

// Load saved theme from localStorage on page load
function loadTheme() {
	const savedTheme = localStorage.getItem('theme');
	if (savedTheme) {
		html.setAttribute('data-bs-theme', savedTheme);
	}
	updateIcon();
	updatePrismTheme();
}

// Update the icon based on the current theme
function updateIcon() {
	const theme = html.getAttribute('data-bs-theme');
	icon.className = theme === 'dark' ? 'bi-toggle-on fs-5' : 'bi-toggle-off fs-5';
}

function updatePrismTheme() {
	const theme = html.getAttribute('data-bs-theme');
	prismNord.disabled = theme === 'light';
	prismLight.disabled = theme === 'dark';
}


// Toggle theme and save preference
toggleLink.addEventListener('click', function (e) {
	e.preventDefault();
	const currentTheme = html.getAttribute('data-bs-theme');
	const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
	html.setAttribute('data-bs-theme', newTheme);
	localStorage.setItem('theme', newTheme); // Save theme
	updateIcon();
	updatePrismTheme();
});

// Initialize theme on page load
loadTheme();

//------------------------ END toggle and save theme functionality ------------------------//
