function filechange(time)
time=time*10;
fid=fopen('sorption.btn');
count_1=1;
str1=[];
while ~feof(fid)
    tline = fgetl(fid);
    str1{count_1}=tline;
    count_1=count_1+1;
end
fclose(fid);
if time>9
str1{count_1-2}=strcat(num2str(time),'.000000      200 1.0000000');
else
str1{count_1-2}=strcat(num2str(time),'.0000000      200 1.0000000');
end;
fid=fopen('sorption.btn','w');
for i=1:count_1-1
    if i==count_1-2
        fprintf(fid,'%s%s\n',' ',str1{i});
    else
        fprintf(fid,'%s\n',str1{i});
    end;
end
fclose(fid);
fid=fopen('sorption.dis');
count_2=1;
str2=[];
while ~feof(fid)
    tline = fgetl(fid);
    str2{count_2}=tline;
    count_2=count_2+1;
end
fclose(fid);
str2{count_2-1}=strcat(num2str(time),'.0 200 1.0 TR');
fid=fopen('sorption.dis','w');
for i=1:count_2-1
        fprintf(fid,'%s\n',str2{i});
end
fclose(fid);