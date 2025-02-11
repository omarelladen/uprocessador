import math

num_max = 30
num_max_verif = math.floor(math.sqrt(num_max))
num_list = list(range(2, num_max+1))



for i in num_list:
  if (i > num_max_verif):
    break
  for j in range(i*2, num_max+1, i):
    if (j in num_list and j % i == 0):
      num_list.remove(j)

print(num_max)
print(num_max_verif)
print(num_list)
print(len(num_list))