echo "     ##### Local - valid id/password #####     "
ruby ./test.approx.single_dic.02.rb "priancho@gmail.com" "password" "http://localhost:3000/dictionaries/EntrezGene%20-%20Homo%20Sapiens/text_annotation?matching_method=approximate&max_tokens=6&min_tokens=1&threshold=0.6&top_n=10"
echo "     ##### Local - valid guest #####     "
ruby ./test.approx.single_dic.02.rb "" "" "http://localhost:3000/dictionaries/EntrezGene%20-%20Homo%20Sapiens/text_annotation?matching_method=approximate&max_tokens=6&min_tokens=1&threshold=0.6&top_n=10"
echo "     ##### Local - private dictionary with invalid email/password #####     "
ruby ./test.approx.single_dic.02.rb "priancho@gmail.com_invalid" "password" "http://localhost:3000/dictionaries/private%20sample%20dictionary/text_annotation?matching_method=approximate&max_tokens=6&min_tokens=1&threshold=0.6&top_n=10"
echo "     ##### Local - invalid email #####     "
ruby ./test.approx.single_dic.02.rb "priancho@gmail.com_invalid" "password" "http://localhost:3000/dictionaries/EntrezGene%20-%20Homo%20Sapiens/text_annotation?matching_method=approximate&max_tokens=6&min_tokens=1&threshold=0.6&top_n=10"
echo "     ##### Local - invalid password#####     "
ruby ./test.approx.single_dic.02.rb "priancho@gmail.com" "password_invalid" "http://localhost:3000/dictionaries/EntrezGene%20-%20Homo%20Sapiens/text_annotation?matching_method=approximate&max_tokens=6&min_tokens=1&threshold=0.6&top_n=10"
echo "     ##### Local - invalid uri #####     "
ruby ./test.approx.single_dic.02.rb "priancho@gmail.com" "password" "http://localhost:3000/dictionaries/EntrezGene%20-%20Homo%20Sapiens_invalid/text_annotation?matching_method=approximate&max_tokens=6&min_tokens=1&threshold=0.6&top_n=10"

