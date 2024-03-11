import { useAuth } from "~/store/user";

export default defineNuxtPlugin(() => {
  const token = useCookie("token");
  const config = useRuntimeConfig();
  const $api = $fetch.create({
    baseURL: config.public.baseURL,
    headers: {
      "Content-Type": 'application/json',
      "Authorization": "bearer " + token.value
    }
  })
  return {
    provide: {
      api: $api
    }
  }
});
