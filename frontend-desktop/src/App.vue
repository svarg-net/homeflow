<template>
  <div class="flex min-h-screen items-center justify-center bg-gradient-to-br from-indigo-500 to-purple-600">
    <div class="rounded-2xl bg-white/10 p-8 text-center text-white backdrop-blur-md shadow-xl">
      <h1 class="text-4xl font-bold mb-4">HomeFlow Desktop</h1>
      
      <!-- Показываем статус API -->
      <div class="mt-6">
        <p class="text-lg mb-2">Статус API:</p>
        
        <!-- Загрузка -->
        <p v-if="loading" class="text-indigo-200">
          Проверяем...
        </p>
        
        <!-- Ошибка -->
        <p v-else-if="error" class="text-red-300">
          Ошибка: {{ error }}
        </p>
        
        <!-- Успех -->
        <p v-else class="text-green-300">
          ✅ {{ healthData?.message }}
        </p>
      </div>
      
      <!-- Кнопка для повторной проверки -->
      <button 
        @click="checkApiHealth"
        class="mt-6 rounded-lg bg-white px-6 py-2 font-semibold text-indigo-600 transition hover:bg-indigo-50"
      >
        Проверить API
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { checkHealth, type HealthResponse } from '@/api/health'

// Reactive переменные (меняются → обновляется UI)
const loading = ref<boolean>(false)
const error = ref<string | null>(null)
const healthData = ref<HealthResponse | null>(null)

// Функция проверки API
async function checkApiHealth(): Promise<void> {
  loading.value = true
  error.value = null
  
  try {
    healthData.value = await checkHealth()
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Неизвестная ошибка'
  } finally {
    loading.value = false
  }
}

// Вызываем при монтировании компонента
onMounted(() => {
  checkApiHealth()
})
</script>