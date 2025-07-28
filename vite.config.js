// vite.config.js
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  base: '/nawah-token-ui/', // غيّر هذا إذا اختلف اسم المستودع
  plugins: [react()],
})
