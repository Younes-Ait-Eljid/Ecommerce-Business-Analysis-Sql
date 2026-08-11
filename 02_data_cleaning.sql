

-- Convert empty review titles to NULL
UPDATE reviews
SET review_comment_title = NULL
WHERE review_comment_title = '';

-- Convert empty review messages to NULL
UPDATE reviews
SET review_comment_message = NULL
WHERE review_comment_message = '';
/*
Purpose:
Convert empty strings to NULL so missing review comments are represented
correctly and can be handled consistently in SQL analysis.
*/