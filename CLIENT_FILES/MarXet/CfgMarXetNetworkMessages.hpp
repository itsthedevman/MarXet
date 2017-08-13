class buyNowRequest
{
	module = "MarXet";
	parameters[] = {"STRING","STRING"};
};
class buyerBuyNowResponse
{
	module = "MarXet";
	parameters[] = {"ARRAY","STRING","STRING","STRING"};
};
class sellerBuyNowResponse
{
	module = "MarXet";
	parameters[] = {"ARRAY"};
};
class createNewListingRequest
{
	module = "MarXet";
	parameters[] = {"ARRAY"};
};
class createNewListingResponse
{
	module = "MarXet";
	parameters[] = {"BOOL","STRING","STRING","SCALAR"};
};
class updateInventoryRequest
{
    module = "MarXet";
    parameters[] = {"SCALAR"};
};
class updateInventoryResponse
{
	module = "MarXet";
	parameters[] = {"ARRAY"};
};
