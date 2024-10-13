
Create table #strings(name_string varchar(30));
insert into #strings values('Ankit Bansal'),
							('Utkarsh Choubey'),
							('Narendra Damodar Das Modi'),
							('Mukesh Ambani'),
							('Vangipurapu Venkata Sai Laxman'),
                            ('Shubham'),
                            ('Mahendra Singh Dhoni'),
                            ('Sanjay Ajay Vijay Parajay');



select * from #strings;

-- Count number of occurence of a character or word in a string

Select name_string, replace (name_string,' ','') as rep_name,
len(name_string) - len(replace (name_string,' ','')) as cnt
from #strings

Select name_string, replace (name_string,'aj','') as rep_name,
(len(name_string) - len(replace (name_string,'aj','')))/len('aj') as cnt
from #strings


Select name_string, 
len(name_string) as str_len, 
replace(name_string, ' ', '') as rep_name_string, 
len(replace(name_string, ' ', ''))  as len_without_spaces,
len(name_string) - len(replace(name_string, ' ', ''))  as no_of_spaces,
len(name_string) - len(replace(name_string, ' ', '')) + 1 as no_of_words,
len(name_string) - len(replace(name_string, 'jay', ''))  as wrong_no_of_chars,
cast((len(name_string) - len(replace(name_string, 'jay', '')))/len('jay') as int)  as right_no_of_chars 
from #strings;


