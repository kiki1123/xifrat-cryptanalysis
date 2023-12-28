def collision(file_path):
    with open(file_path, 'r') as file:
        list=[]
        count =0
        lines = [line.strip() for line in file]
        for i in range(len(lines)-1):
            if lines[i] not in list:
                for j in range(i+1,len(lines)):
                    if lines[i]==lines[j]:
                        count+=1
                        if lines[i] not in list:
                            list.append(lines[i])
    return count


def truncated_collision(file_path,n,p):
    with open(file_path, 'r') as file:
        list=[]
        count =0
        lines = [line.strip()[n:p+1] for line in file]
        for i in range(len(lines)-1):
            if lines[i] not in list:
                for j in range(i+1,len(lines)):
                    if lines[i]==lines[j]:
                        count+=1
                        if lines[i] not in list:
                            list.append(lines[i])
    return count


def check(file_path):
    with open(file_path, 'r') as file:
        lines = [line.strip() for line in file]
    return len(lines)

