// Xử lý hiệu ứng loading
document.querySelectorAll('form').forEach(form => {
    form.addEventListener('submit', () => {
        showLoading();
    });
});

function showLoading() {
    const overlay = document.createElement('div');
    overlay.style.position = 'fixed';
    overlay.style.top = '0';
    overlay.style.left = '0';
    overlay.style.width = '100%';
    overlay.style.height = '100%';
    overlay.style.backgroundColor = 'rgba(255, 255, 255, 0.8)';
    overlay.style.zIndex = '9999';
    overlay.innerHTML = `
        <div class="spinner-border text-primary" style="position: absolute; top: 50%; left: 50%">
            <span class="visually-hidden">Loading...</span>
        </div>
    `;
    document.body.appendChild(overlay);
}

// Xử lý seat selection
document.querySelectorAll('.seat').forEach(seat => {
    if (!seat.classList.contains('booked')) {
        seat.addEventListener('click', () => {
            seat.classList.toggle('selected');
            updateSelectedSeats();
        });
    }
});

function updateSelectedSeats() {
    const selectedSeats = document.querySelectorAll('.seat.selected');
    document.getElementById('selectedSeats').value = 
        Array.from(selectedSeats).map(seat => seat.dataset.seatNumber).join(',');
} 