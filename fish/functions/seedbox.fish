function seedbox --wraps='ssh home -L localhost:8081:localhost:8081 -N' --description 'alias seedbox ssh home -L localhost:8081:localhost:8081 -N'
  ssh home -L localhost:8081:localhost:8081 -N $argv; 
end
