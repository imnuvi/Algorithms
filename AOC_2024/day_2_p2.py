
def check_safety(safe_list, mindiff):
    lkey = True
    rkey = True
    for i in range(1, len(safe_list)):
        x = safe_list[i] 
        y = safe_list[i-1]
        if not ((abs(x - y) <= mindiff)  and x < y):
            lkey = False
        if not ((abs(x - y) <= mindiff)  and x > y):
            rkey = False
    return lkey or rkey

def run():
    mindiff = 3
    res = 0
    with open('inputs/day_2.txt', 'r') as f:
        lines = f.readlines()
    for line in lines:
        parsed_list = list(map(int, line.split()))
        # this is day 1
        # print(check_safety(parsed_list, mindiff))
        for i in range(len(parsed_list)):
            if check_safety(parsed_list[:i] + parsed_list[i+1:], mindiff):
                res += 1
                break
    return res

print(run())