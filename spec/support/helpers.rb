def set_session(vars = {})
  post test_session_path, params: { session_vars: vars }
end
