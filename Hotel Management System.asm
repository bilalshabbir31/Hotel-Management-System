.stack 100h

.data

str1 db "Enter Username: $"
str2 db 13,10,"Enter Password: $"

m1 db "***********************$"
str3 db "Hotel Management System$"
m2 db "***********************$"
m3 db 13,10,"Press 1. To login as Admin $"
m4 db 13,10,"Press 2. To login as Customer $" 
m5 db 13,10,"Press 3. To quit $"
m6 db 13,10,"Enter your choice: $"

m7 db 13,10,"You have entered an Invalid choice...Please enter again $"
str4 db "=======================$"
str5 db "    Admin Portal $"
str6 db "=======================$"
str7 db 13,10,"You have entered an invalid password...Try again!!! $"
str8 db 13,10,"Press 1. To Add Room $"
str9 db 13,10,"Press 2. To Search Room $"
str10 db 13,10,"Press 3. To Delete Room $"
str11 db 13,10,"Press 4. To Display Room details $"  
st12 db 13,10,"Press 5. Back to Main Menu $"

str12 db 13,10,"Enter Room No: $"
str16 db 13,10,"Enter Room Rent: $"
str17 db 13,10,"Enter Type[Select 1 or 2]: $"
str13 db 13,10,"Record...Not found $"
str15 db 13,10,"You have entered an invalid username...Try again!!! $"

str18 db "   Customer Portal $"
str19 db 13,10,"Press 1. To check room availability $"
str20 db 13,10,"Press 2. To Display Room details $"
str21 db 13,10,"Press 3. Book a room $"
st22 db 13,10,"Press 4. Back to Main Menu $"

str23 db 13,10,"Press 1. To check room availability by room number $" 
str24 db 13,10,"Press 2. Back to Customer Menu $"
str25 db 13,10,"      Available! $"
str26 db 13,10,"      Not Available! $"
str27 db 13,10,"Do you want to book this room [Y|N] $"
str28 db 13,10,"Room has been booked! $"

success db 13,10, "Room created successfully $"
no_success db 13,10,"Invalid Room no. Enter 3 digits $"
no_success2 db 13,10,"Invalid Room Rent. Enter 4 digits $"
no_success3 db 13,10,"Invalid Room Type. Enter 1 or 2 $"
str14 db "Room info $"

un db 20 dup('$')
pass db 20 dup('$')

user db "admin"
password db "1234" 

count db ?
countusername db ?
counttype db ?
   
Len dw 4
lenun dw 5

roomno dw 20 dup('$')
roomrent dw 20 dup('$')
roomtype dw 20 dup('$')

rtype1 db "AC $"
rtype2 db "Non AC $"
one db "1) $"
two db "2) $"
                                      
var1 db ?
var2 db ?
check1 db ? 
 
 
Sear_Room db "Search Room $"
RN db 13,10,"Room No: $"        ;Room No:
RR db 13,10,"Room Rent: $"      ;Room Rent:
RT db 13,10,"Room Type: $"      ;Room Type
      
search dw 20 dup('$')
Delete db 13,10,"Room Deleted Successfully! $"

.code
main proc              
mov ax,@data
mov ds,ax

push ax              ;ax  12
push bx              ;bx  10
push cx              ;cx  8
push dx              ;dx  6
push si              ;si  4
push di              ;di  2
push bp              ;bp  0
mov bp,sp

call welcome_screen  ;calling welcome_screen procedure
call main_menu       ;calling main_menu procedure   

pop bp               ;bp 0
pop di               ;di 2
pop si               ;si 4
pop dx               ;dx 6
pop cx               ;cx 8
pop bx               ;bx 10
pop ax               ;ax 12

call exit            ;calling exit procedure
endp

welcome_screen proc  
mov dh,0      ;dh->row=1
mov dl,29     ;dl->col=29
mov ah,2      ;ah=2
int 10h       ;BIOS interrupt

lea dx,m1
mov ah,09h    ;*************************
int 21h 

mov dh,1      
mov dl,29     
mov ah,2
int 10h

lea dx,str3
mov ah,09h    ;Hotel Management System
int 21h  

mov dh,2
mov dl,29
mov ah,2
int 10h

lea dx,m2
mov ah,09h    ;*************************
int 21h 

ret    
welcome_screen endp
   
main_menu proc              
again1:
lea dx,m3            ;Press 1. To login as Admin 
mov ah,09h           
int 21h

lea dx,m4            ;Press 2. To login as Customer
int 21h
              
lea dx,m5            ;Press 3. To quit
int 21h
              
lea dx,m6            ;Enter your choice:
int 21h
              
mov ah,01h
int 21h

cmp al,31h           ;if al<1 && al>3 then goto label invalid
jnae invalid
cmp al,33h
jnbe invalid

 valid:
 cmp al,31h
 je admin            ;if al==1 then goto admin label
 cmp al,32h
 je customer         ;if al==2 then goto customer label
 cmp al,33h
 je quit             ;if al==3 then goto quit label
 
 admin:
 call admin_login    ;calling admin_login procedure
 jmp return1 
 
 customer:
 call customer_portal
 jmp return1         ;calling customer_login procedure
 
 quit:
 call exit           ;calling exit procedure
  
 invalid:  
 mov ah,09h
 lea dx,m7           ;You have entered an Invalid choice...Please enter again
 int 21h     
 mov ah,08h          ;character input without echo
 int 21h
 call clear_screen
 call set_registers
 call welcome_screen 
 jmp again1
 
return1:  
ret
endp                  ;ret admin_login  -4
                      ;ret main        -2
admin_login proc      
again2:   
call clear_screen
call set_registers   
call admin_portal

lea dx,str1
mov ah,09h            ;Enter Username
int 21h

mov bx,offset un
mov [countusername],0 ;Take input from user in Un(user) array
while_UserName:
mov ah,08h            ;get character input without echo
int 21h
cmp al,0dh
je end_While_username
mov [bx],al
mov dl,al
mov ah,02h
int 21h               ;display "admin"
inc bx
inc [countusername]
jmp while_UserName

end_While_username:
lea si,un
lea di,user
mov ax,[Lenun]          ;checking by count character un and user
cmp al,[countusername]
jne not_equal_Username  ;if it is not true then goto not_equal_Username
jmp checkUsername    
             
not_equal_Username:
mov dh,5          ;row=5
mov dl,0          ;col=0
mov ah,02         ;ah=02h (sub-routine for gotoxy)
int 10h           ;BIOS interrupt             
       
lea dx,str15           
mov ah,09h        ;You have entered an invalid username...Try again!!!    
int 21h     
   
mov ah,08h        ;wait for user to enter a key
int 21h
                      
call clear_screen ;calling clear_screen procedure   
jmp again2       
            
checkUserName:
mov ch,0
mov cl,[countusername]   
mov bx,offset user
mov si,offset un
compareUserName:          ;comparing two strings character by character 
mov al,[bx]
cmp al,[si]
jne not_equal  
inc bx
inc si
loop compareUserName            
            
             
lea dx,str2
mov ah,09h    ;Enter Password
int 21h
mov bx,0
mov ax,0
mov bx,offset pass
mov [count],0 ;Take input from user in Pass array   
while:
mov ah,08h    ;get character input without echo
int 21h
cmp al,0dh    
je end_while  ;if al=enter key ascii then goto label end_while
mov [bx],al   ;store input in pass array
mov ah,02h
mov dl,'*'    ;print *
int 21h
inc bx        ;increment address
inc [count]   ;count number of characters
jmp while

end_while:

lea si,password   
lea di,pass       
mov ax,[Len]     
cmp al,[count]
jne not_equal
jmp check

not_equal: 
mov dh,5          ;row=5
mov dl,0          ;col=0
mov ah,02         ;ah=02h (sub-routine for gotoxy)
int 10h           ;BIOS interrupt
                       
lea dx,str7           
mov ah,09h        ;You have entered an invalid password...Try again!!!    
int 21h               

mov ah,08h        ;wait for user to enter a key
int 21h
                      
call clear_screen ;calling clear_screen procedure   
jmp again2             

check:
mov ch,0
mov cl,[count]   
mov bx,offset pass
mov si,offset password
compare:          ;comparing two strings character by character 
mov al,[bx]
cmp al,[si]
jne not_equal  
inc bx
inc si
loop compare 

call clear_screen       ;calling clear_screen procedure                    
call set_registers      ;calling set_registers procedure
call admin_portal       ;calling admin_portal procedure
call admin_main_menu    ;calling admin_main_menu procedure

return:        
ret                     ;returning from admin_login procedure
admin_login endp    

clear_screen proc
mov ax,0600h  ;ah=6 scroll up function, al=no of lines to scroll (0 = whole screen)
mov cx,0      ;ch=upper left corner row, cl=upper left corner column 
mov dx,2479   ;dh=lower right corner row, dl=lower right corner column
mov bh,7      ;normal video attribute
int 10h       ;BIOS interrupt
ret
clear_screen endp    

admin_portal proc 
mov dh,0
mov dl,29
mov ah,2
int 10h

lea dx,str4
mov ah,09h        ;=========================
int 21h 

mov dh,1
mov dl,29
mov ah,2
int 10h

lea dx,str5
mov ah,09h              ;Admin Portal
int 21h 

mov dh,2
mov dl,29
mov ah,2
int 10h
  
lea dx,str6
mov ah,09h        ;===========================
int 21h

mov dh,3
mov dl,0
mov ah,02h
int 10h
    
ret
admin_portal endp    

admin_main_menu proc  

mov dh,2     ;row=2
mov dl,29    ;col=29
mov ah,2    
int 10h      ;BIOS interrupt

lea dx,str8
mov ah,09h   ;Press 1. To Add Room
int 21h 

mov dh,3
mov dl,29    ;
mov ah,2
int 10h

lea dx,str9
mov ah,09h   ;Press 2. To Search Room
int 21h  

mov dh,4
mov dl,29    ;
mov ah,2
int 10h

lea dx,str10
mov ah,09h   ;Press 3. To Delete Room
int 21h 

mov dh,5
mov dl,29
mov ah,2
int 10h

lea dx,str11
mov ah,09h   ;Press 4. To Display Room details
int 21h 

lea dx,st12
mov ah,09h   ;Press 5. Back to Main Menu
int 21h 

lea dx,m6
mov ah,09h   ;Enter your choice:
int 21h 

mov ah,01h
int 21h      
mov bl,al

cmp bl,31h         ;if bl<1 && bl>5 then goto label invalid2
jnae invalid2
cmp bl,35h
jnbe invalid2   

valid2:
     cmp bl,31h
     je create_room  ;if bl==1 then goto create_acc label
          
     cmp bl,32h
     je search_room   ;if bl==2 then goto search_acc label
         
     cmp bl,33h
     je delete_room   ;if bl==3 then goto delete_acc label
     
     cmp bl,34h
     je show_room  ;if bl==4 then goto show_userss label
     
     cmp bl,35h
     je back         ;if bl==5 then goto back label
     
     create_room:
     call add_room
     jmp return3
     
     searchroom:
     call search_room
     jmp return3  
     
     deleteroom:
     call delete_room
     jmp return3
     
     show_room:
     call show_users
     jmp return3
     
     back:
     call clear_screen
     call set_registers
     call welcome_screen
     call main_menu
     jmp return3
          
     invalid2:
     lea dx,m7
     mov ah,09h
     int 21h
     mov ah,08h
     int 21h  
     
     call clear_screen
     call set_registers
     call admin_portal 
     call admin_main_menu
                         
return3:
ret    
admin_main_menu endp
  
customer_portal proc
              
call clear_screen
call set_registers  
              
mov dh,0      
mov dl,29    
mov ah,2      
int 10h       

lea dx,str4
mov ah,09h      ;==========================
int 21h 

mov dh,1      
mov dl,29     
mov ah,2
int 10h

lea dx,str18
mov ah,09h       ;Customer portal
int 21h  

mov dh,2
mov dl,29
mov ah,2
int 10h

lea dx,str6
mov ah,09h      ;==========================
int 21h 

call Customer_main_menu

mov dh,3
mov dl,0
mov ah,02h
int 10h

ret
customer_portal endp

customer_portal_1 proc
              
call clear_screen
call set_registers  
              
mov dh,0      
mov dl,29    
mov ah,2      
int 10h       

lea dx,str4
mov ah,09h      ;==========================
int 21h 

mov dh,1      
mov dl,29     
mov ah,2
int 10h

lea dx,str18
mov ah,09h       ;Customer portal_1
int 21h  

mov dh,2
mov dl,29
mov ah,2
int 10h

lea dx,str6
mov ah,09h      ;==========================
int 21h 

mov dh,3
mov dl,0
mov ah,02h
int 10h

ret
customer_portal_1 endp


Customer_main_menu proc

mov dh,2     ;row=2
mov dl,29    ;col=29
mov ah,2    
int 10h      ;BIOS interrupt

lea dx,str19
mov ah,09h   ;Press 1. To check room availability 
int 21h 

mov dh,3
mov dl,29    ;
mov ah,2
int 10h

lea dx,str20
mov ah,09h   ;Press 2. To Display Room details
int 21h  
          
mov dh,4
mov dl,29    ;
mov ah,2
int 10h

lea dx,str21
mov ah,09h   ;Press 3. Book a room
int 21h 

mov dh,5
mov dl,29
mov ah,2
int 10h

lea dx,st22
mov ah,09h   ;Press 4. Back to Main Menu
int 21h 

lea dx,m6
mov ah,09h   ;Enter your choice:
int 21h 

mov ah,01h
int 21h      
mov bl,al

cmp bl,31h         ;if bl<1 && bl>4 then goto label invalid2
jnae invalid3
cmp bl,34h
jnbe invalid3   

valid3:             
     cmp bl,31h
     je check_RM_availablility  ;if bl==1 then goto check_room_availablility label
          
     cmp bl,32h
     je show_room  ;if bl==2 then goto show_userss label
     
     cmp bl,33h
     je book_a_room  ;if bl==3 then goto book_a_room label
     
     cmp bl,34h
     je back         ;if bl==5 then goto back label
     
     check_RM_availablility:
     call check_room_availablility
    
     
     show_room2:
     call show_users
 
     
     book_a_room:
     call book_a_room_1
     jmp return4
     
     back2:
     call clear_screen
     call set_registers
     call Customer_main_menu
     
          
     invalid3:
     lea dx,m7        ;You have entered an Invalid choice...Please enter again
     mov ah,09h
     int 21h
     mov ah,08h
     int 21h  
     
     call clear_screen
     call set_registers
     call Customer_portal
     call Customer_main_menu  

return4:              
ret
Customer_main_menu endp
                 
check_room_availablility proc
call clear_screen
call set_registers
call Customer_portal_1

mov dh,2                 ;row=2
mov dl,29                ;col=29
mov ah,2    
int 10h                  ;BIOS interrupt

lea dx,str23   
mov ah,09h               ;Press1. To check room availability by room number
int 21h

mov dh,3                 ;row=3
mov dl,29                ;col=29
mov ah,2    
int 10h                  ;BIOS interrupt

lea dx,str24   
mov ah,09h               ;Press2. Back to Customer Menu
int 21h

mov dh,4                 ;row=4
mov dl,29                ;col=29
mov ah,2    
int 10h                  ;BIOS interrupt
      
lea dx,m6   
mov ah,09h               ;Enter your choice
int 21h       
                                               
mov ah,01h
int 21h
mov bl,al

cmp bl,31h               ;if bl<1 && bl>2 then goto label invalid4
je valid4
cmp bl,32h
je back1   
jmp invalid4

     valid4:
     jmp To_check_room_availability_by_room_number           ;if bl==1 then goto To_check_room_availability by room number label
     
                                                             ;if bl==2 then goto back label
     To_check_room_availability_by_room_number:
     call search_room_1 
         
     back1:
     call clear_screen
     call set_registers
     call Customer_portal_1
     call Customer_main_menu
          
     invalid4:
     lea dx,m7
     mov ah,09h
     int 21h
     mov ah,08h
     int 21h                                                                 
     
call clear_screen
call set_registers
call Customer_portal 
call Customer_main_menu                                   
ret
check_room_availablility endp
 
show_users_2 proc
               
call clear_screen
call set_registers
call Customer_portal_1

mov dh,3      ;dh->row=3
mov dl,34     ;dl->col=34
mov ah,2      ;ah=2
int 10h       ;BIOS interrupt

lea dx,str14
mov ah,09h       ;Room info:
int 21h

mov si,2
mov dx,roomno[si]
cmp dx,'$'
je empty         

lea dx,str25
mov ah,09h
int 21h 

         
lea dx,RN
mov ah,09h       ;Room No:
int 21h
                
mov ch,0        ;display Room No
mov cl,3
mov ah,02h
displayroomNo:
mov dx,roomno[si]
mov ah,02h
int 21h
inc si
loop displayroomNo

lea dx,RR
mov ah,09h       ;Room Rent:
int 21h 

mov ch,0        ;display Room Rent
mov cl,4
mov ah,02h
mov si,2
displayRoomRent:
mov dx,roomrent[si]
mov ah,02h
int 21h               
inc si
loop displayRoomRent

lea dx,RT
mov ah,09h       ;Room Type:
int 21h 

DisplayAC:     ;display Room Type
mov ch,0
mov cl,[counttype]
mov ax,0       
mov bx,offset roomtype
displayRoomType:
mov dx,[bx]
mov ah,02h 
int 21h
inc bx
loop displayRoomType
  
jmp w2

empty:
lea dx,str13
mov ah,09h       ;Record...Not found
int 21h

w2:
mov ah,08h       ;wait for input
int 21h  


call clear_screen
call set_registers
call Customer_portal_1 
    
ret
show_users_2 endp  
  
book_a_room_1 proc
call clear_screen
call set_registers
call Customer_portal_1
call show_users_2          ;display record of room 
  
lea dx,str27
mov ah,09h
int 21h

mov ah,01h
int 21h
mov bl,al 
 
cmp bl,'Y'
je book_room_1
cmp bl,'y'
je book_room_1 
jmp next 
        book_room_1: 
        mov [check1],31h
        
        lea dx,str28
        mov ah,09h
        int 21h
next:
cmp bl,'N'
je book_room_2
cmp bl,'n'
je book_room_2

        book_room_2:
        mov ah,08h
        int 21h

call clear_screen
call set_registers
call Customer_portal_1 
call Customer_main_menu
     
ret
book_a_room_1 endp
 
add_room proc
again4:
call clear_screen
call set_registers
call admin_portal

lea dx,str12   
mov ah,09h         ;Enter Room no:
int 21h

mov ah,10
lea dx,roomno     ;Take string input in roomno
mov roomno,4
int 21h              

mov ah,0
mov ax,[roomno+1]
inc var1
cmp al,3          
jne create_again

mov var1,0         ;Making zero in Var1

lea dx,str16   
mov ah,09h         ;Enter Room Rent:
int 21h

mov ah,10
lea dx,roomrent     ;Take string input in roomrent
mov roomrent,5
int 21h

mov ah,0
mov ax,[roomrent+1]
inc var2
cmp al,4          
jne create_again

mov var2,0

mov dh,6      ;dh->row=6
mov dl,29     ;dl->col=29
mov ah,2      ;ah=2
int 10h       ;BIOS interrupt

lea dx,one   
mov ah,09h         ;1)
int 21h

lea dx,rtype1   
mov ah,09h         ;AC
int 21h

lea dx,two
mov ah,09h         ;2)
int 21h

lea dx,rtype2   
mov ah,09h         ;Non AC
int 21h

lea dx,str17   
mov ah,09h         ;Enter Room Type:
int 21h

mov ah,01h         ;input 1 or 2
int 21h
cmp al,31h         ;comp with 1
jnae create_again
cmp al,32h         ;comp with 2
jnbe create_again
cmp al,31h
je ACtypelabel
cmp al,32h
je NonACtypelabel

ACtypelabel:
mov ch,0
mov cl,2
mov bx,offset roomtype
mov si,offset rtype1
mov ax,0
AddACLabel:
mov al,[si]
mov [bx],al
inc bx
inc si
inc counttype
loop AddACLabel
jmp SuccessFullyADDED

NonACtypelabel:
mov ch,0
mov cl,6
mov bx,offset roomtype
mov si,offset rtype2
mov ax,0
AddNonACLabel:
mov al,[si]
mov [bx],al
inc bx
inc si
inc counttype
loop AddNonACLabel

SuccessFullyADDED:
lea dx,success
mov ah,09h         ;Room created successfully
int 21h   
mov ah,08h
int 21h 
jmp last

create_again:
cmp var1,0
jne if
cmp var2,0
jne elseif
jmp else
if:
lea dx,no_success
mov ah,09h         ;Invalid Room no. Enter 3 digits
int 21h
mov ah,08h
int 21h 
jmp again4

elseif:
lea dx,no_success2
mov ah,09h         ;Invalid Room Rent. Enter 3 digits
int 21h
mov ah,08h
int 21h 
jmp again4

else:
lea dx,no_success3
mov ah,09h         ;Invalid Room Type. Enter 1 or 2
int 21h
mov ah,08h
int 21h 
jmp again4

last:
call clear_screen
call set_registers
call admin_portal
call admin_main_menu   
ret
add_room endp    

search_room proc
call input_Search
call show_users
jmp w
call clear_screen
call set_registers
call admin_portal
call admin_main_menu   
ret
search_room endp

search_room_1 proc

call input_Search_1
     mov dx,0
     mov dl,[check1]
     cmp dl,31h
     je if1
     jmp else1  
        
     if1:
     lea dx,str26
     mov ah,09h 
     int 21h 
     mov ah,08h 
     int 21h
      
     jmp next1
      
     else1: 
     call show_users_1

next1:     
jmp w
call clear_screen
call set_registers
call Customer_portal_1
call Customer_main_menu   
ret
search_room_1 endp

input_Search_1 proc
call clear_screen
call set_registers
call Customer_portal_1
               
mov dh,3      ;dh->row=3
mov dl,34     ;dl->col=34
mov ah,2      ;ah=2
int 10h       ;BIOS interrupt               

lea dx,Sear_Room
mov ah,09h       ;Room Search:
int 21h

lea dx,str12   
mov ah,09h         ;Enter Room no:
int 21h

mov ah,10
lea dx,search    ;Take string input in Search
mov search,4
int 21h    

mov ah,0
mov ax,[search+1]
cmp al,3
jne NotFound

mov bx,offset roomno
mov si,offset search
mov ch,0
mov cl,3
mov ax,0
Found:
mov al,[bx]
cmp al,[si]
jne NotFound
inc bx
inc si
loop Found
mov ch,0
mov cl,1
jmp returntoSearch
NotFound:
lea dx,str26
mov ah,09h
int 21h
mov ah,08h
int 21h
jmp w
returntoSearch:
ret    
input_Search_1 endp
      
show_users_1 proc 
call clear_screen
call set_registers
call Customer_portal_1

mov dh,3      ;dh->row=3
mov dl,34     ;dl->col=34
mov ah,2      ;ah=2
int 10h       ;BIOS interrupt

lea dx,str14
mov ah,09h       ;Room info:
int 21h

mov si,2
mov dx,roomno[si]
cmp dx,'$'
je empty         

lea dx,str25
mov ah,09h
int 21h 

         
lea dx,RN
mov ah,09h       ;Room No:
int 21h
                
mov ch,0        ;display Room No
mov cl,3
mov ah,02h
displayroomNo1:
mov dx,roomno[si]
mov ah,02h
int 21h
inc si
loop displayroomNo1

lea dx,RR
mov ah,09h       ;Room Rent:
int 21h 

mov ch,0        ;display Room Rent
mov cl,4
mov ah,02h
mov si,2
displayRoomRent1:
mov dx,roomrent[si]
mov ah,02h
int 21h               
inc si
loop displayRoomRent1

lea dx,RT
mov ah,09h       ;Room Type:
int 21h 

DisplayAC1:     ;display Room Type
mov ch,0
mov cl,[counttype]
mov ax,0       
mov bx,offset roomtype
displayRoomType1:
mov dx,[bx]
mov ah,02h 
int 21h
inc bx
loop displayRoomType1
  
jmp w1

empty1:
lea dx,str13
mov ah,09h       ;Record...Not found
int 21h

w1:
mov ah,08h       ;wait for input
int 21h  

call clear_screen
call set_registers
call Customer_portal_1 
call Customer_main_menu
    
ret
show_users_1 endp 




delete_room proc
call input_search
mov bx,0
mov ch,0
mov cl,3
dRoom:
mov roomno[bx],'$'
inc bx
loop dRoom

mov si,2
mov ch,0
mov cl,4
dRoomrent:
mov roomrent[si],'$'
inc si
loop dRoomrent

mov bx,0
mov bx,offset roomtype
mov ch,0
mov cl,[counttype]
dac:
mov [bx],'$'
inc bx
loop dac
mov [counttype],0
lea dx,Delete  ;Delete Room Successfully! 
mov ah,09h
int 21h
jmp w
delete_room endp
         
show_users proc 
call clear_screen
call set_registers
call admin_portal

mov dh,3      ;dh->row=3
mov dl,34     ;dl->col=34
mov ah,2      ;ah=2
int 10h       ;BIOS interrupt

lea dx,str14
mov ah,09h       ;Room info:
int 21h

mov si,2
mov dx,roomno[si]
cmp dx,'$'
je empty         
         
lea dx,RN
mov ah,09h       ;Room No:
int 21h
                
mov ch,0        ;display Room No
mov cl,3
mov ah,02h
displayroomNo_1:
mov dx,roomno[si]
mov ah,02h
int 21h
inc si
loop displayroomNo_1

lea dx,RR
mov ah,09h       ;Room Rent:
int 21h 

mov ch,0        ;display Room Rent
mov cl,4
mov ah,02h
mov si,2
displayRoomRent_1:
mov dx,roomrent[si]
mov ah,02h
int 21h
inc si
loop displayRoomRent_1

lea dx,RT
mov ah,09h       ;Room Type:
int 21h 

DisplayAC_1:     ;display Room Type
mov ch,0
mov cl,[counttype]
mov ax,0       
mov bx,offset roomtype
displayRoomType_1:
mov dx,[bx]
mov ah,02h 
int 21h
inc bx
loop displayRoomType
  
jmp w

empty_1:
lea dx,str13
mov ah,09h       ;Record...Not found
int 21h

w:
mov ah,08h       ;wait for input
int 21h  

call clear_screen
call set_registers
call admin_portal 
call admin_main_menu    
ret
show_users endp    

input_Search proc
call clear_screen
call set_registers
call admin_portal
               
mov dh,3      ;dh->row=3
mov dl,34     ;dl->col=34
mov ah,2      ;ah=2
int 10h       ;BIOS interrupt               

lea dx,Sear_Room
mov ah,09h       ;Room Search:
int 21h

lea dx,str12   
mov ah,09h         ;Enter Room no:
int 21h

mov ah,10
lea dx,search    ;Take string input in Search
mov search,4
int 21h    

mov ah,0
mov ax,[search+1]
cmp al,3
jne NotFound

mov bx,offset roomno
mov si,offset search
mov ch,0
mov cl,3                       
mov ax,0
Found_1:
mov al,[bx]
cmp al,[si]
jne NotFound
inc bx
inc si
loop Found
mov ch,0
mov cl,1
jmp returntoSearch
NotFound_1:
lea dx,str13
mov ah,09h
int 21h
jmp w
returntoSearch_1:
ret    
input_Search endp


set_registers proc
mov ax,[bp+12]        
mov bx,[bp+10]        
mov cx,[bp+8]
mov dx,[bp+6] 
mov si,[bp+4]
mov di,[bp+2] 
ret
set_registers endp    

exit proc
mov ah,4ch
int 21h        
ret
exit endp

end main