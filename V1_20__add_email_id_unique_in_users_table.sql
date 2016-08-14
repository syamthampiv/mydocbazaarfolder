ALTER TABLE  users
  ADD CONSTRAINT uk_users_email_id UNIQUE(email_id);