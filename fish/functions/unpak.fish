function unpak --wraps=pacman\ -Qi\ \|\ rg\ -B\ 14\ -n\ \ \'Required\ By\ \ \ \ \ :\ None\' --wraps=pacman\ -Qi\ \|\ rg\ -B\ 14\ -n\ \ \'Required\ By\ \ \ \ \ :\ None\ \|\ bat\ \' --description alias\ unpak\ pacman\ -Qi\ \|\ rg\ -B\ 14\ -n\ \ \'Required\ By\ \ \ \ \ :\ None\'
  pacman -Qi | rg -B 14 -n  'Required By     : None' $argv; 
end
