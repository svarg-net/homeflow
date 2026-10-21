import apiClient from './client'

export interface HealthResponse {
  status: string
  message: string
  timestamp: string
}

/**
 * Проверить работоспособность API
 */
export async function checkHealth(): Promise<HealthResponse> {
  const response = await apiClient.get<HealthResponse>('/api/health')
  return response.data
}