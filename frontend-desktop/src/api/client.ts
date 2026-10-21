import axios, { type AxiosInstance } from 'axios'

const apiClient: AxiosInstance = axios.create({
  baseURL: import.meta.env.VITE_API_URL || 'http://localhost:8000',
  
  timeout: 5000,
  
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  },
})

apiClient.interceptors.request.use(
  (config) => {
    // Здесь можно добавить токен авторизации
    // const token = localStorage.getItem('token')
    // if (token) {
    //   config.headers.Authorization = `Bearer ${token}`
    // }
    return config
  },
  (error) => {
    return Promise.reject(error)
  }
)

apiClient.interceptors.response.use(
  (response) => {
    return response
  },
  (error) => {
    if (error.response) {
      // Сервер вернул ошибку (4xx, 5xx)
      console.error('API Error:', error.response.status, error.response.data)
    } else if (error.request) {
      // Запрос отправлен, но ответ не получен
      console.error('Network Error:', error.request)
    } else {
      // Ошибка при настройке запроса
      console.error('Error:', error.message)
    }
    return Promise.reject(error)
  }
)

export default apiClient