export async function getJSON(url, options = {}) {
    const response = await fetch(url, options);
    const body = await response.text();
    let data;

    try {
        data = JSON.parse(body);
    } catch (error) {
        throw new Error(`Server returned an unexpected response (HTTP ${response.status})`);
    }

    if (data.error === 'session_expired' || response.status === 401) {
        throw new Error('Your session expired - please log in again to save scores.');
    }

    if (!response.ok || data.ok === false) {
        throw new Error(data.message || data.error || `Request failed: ${response.status}`);
    }

    return data;
}

export async function postForm(url, values = {}) {
    const formData = new FormData();

    Object.entries(values).forEach(([key, value]) => {
        formData.append(key, value);
    });

    return getJSON(url, {
        method: 'POST',
        body: formData,
    });
}

const APP_ROOT_URL = (window.APP_ROOT_URL || '').replace(/\/$/, '');

export const api = {
    loadLevels: () => getJSON(`${APP_ROOT_URL}/game/get_levels.php`),
    loadLevel: (levelId) => getJSON(`${APP_ROOT_URL}/game/get_levels.php?id=${encodeURIComponent(levelId)}`),
    saveScore: (payload) => postForm(`${APP_ROOT_URL}/game/save_score.php`, payload),
};
