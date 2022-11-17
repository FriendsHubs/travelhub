/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./pages/**/*.{js,ts,jsx,tsx}",
    "./components/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        "iris-red": "#FC364C",
        "iris-black": "#0D0D0D",
        "iris-gray": "rgba(13, 13, 13, 0.5)",
        "iris-gray-light": "background: rgba(31, 31, 31, 1)",
        
      },
      screens: {
        'xs': '360px',
        // => @media (min-width: 992px) { ... }
      }
    },
  },
  plugins: [],
};
