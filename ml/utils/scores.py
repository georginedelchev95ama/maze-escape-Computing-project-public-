SCORE_FIELDS = ('level_id', 'time_ms', 'moves', 'won', 'keys_collected')
MAX_SCORES = 10000


def parse_scores(data):
    if not isinstance(data, dict) or not isinstance(data.get('scores'), list):
        return None
    if len(data['scores']) > MAX_SCORES:
        return None

    scores = []
    for item in data['scores']:
        if not isinstance(item, dict):
            return None
        score = {}
        for field in SCORE_FIELDS:
            value = item.get(field)
            if not isinstance(value, int) or isinstance(value, bool) or value < 0:
                return None
            score[field] = value
        if score['won'] not in (0, 1) or score['level_id'] < 1:
            return None
        scores.append(score)

    return scores
