// + Add another list button
const clickAddList = document.querySelector(".clickAddList")
const toggleCard = document.querySelector(".toggleCard")
const clickX = document.querySelector(".clickX")

clickAddList.addEventListener("click",function(e){
clickAddList.style.display ="none";
toggleCard.style.display = "block";
})

clickX.addEventListener("click",function(e){
toggleCard.style.display = "none";
clickAddList.style.display = "block";
})

// Edit title Cards
// const titleCard = document.querySelectorAll(".titleCard")
// const formCard = document.querySelectorAll(".formCard")
// const input_border = document.querySelector(".input_border")

// tiles.forEach((tile)=>{tile.addEventListener("click",addFunctionsAndClass,{once:true})})

// titleCard.forEach((card,index)=>{card.addEventListener("click",function(e){
//   card.style.display ="none";
//   input_border.value = card.innerHTML
//   formCard[index].style.display = "block";
// })})

// clickX.addEventListener("click",function(e){
// toggleCard.style.display = "none";
// clickAddList.style.display = "block";
// })
{/* <div class="formCard" style="display: none;">
<%= form_with scope: :card, url:update_card_path({card_id:card.id}), method: :patch, local: true do |form| %>
  <%= form.text_field :card_title,required: true, class:"input_border" %>
  <!-- <span><%= form.submit "ok" , class:"btn btn-primary" %></span> -->
<% end %>
</div> */}

