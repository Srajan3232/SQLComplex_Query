/*Q1. Who is the senior most employee based on job title?*/
Select top 1 * From employee
order by levels desc

/*Q2.Which countries have the most Invoices?*/
Select top 1 count(*) as C, billing_country from invoice
GROUP BY billing_country
ORDER BY C DESC

/*Q3.What are top 3 values of total invoice?*/
Select top 3 total from invoice
ORDER BY total DESC

/*Q4.Which city has the best customers? We would like to throw a promotional Music
Festival in the city we made the most money. Write a query that returns one city that
has the highest sum of invoice totals. Return both the city name & sum of all invoice
totals?*/
Select top 1 sum(total) as Invoice_Totals,billing_city from invoice
group by billing_city
order by Invoice_Totals desc

/* Q5: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */
SELECT DISTINCT email,first_name, last_name
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
WHERE track_id IN(
	SELECT track_id FROM track
	JOIN genre ON track.genre_id = genre.genre_id
	WHERE genre.name LIKE 'Rock'
)
ORDER BY email;

/* Q6: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */
Select track.name,track.milliseconds
from track
where track.milliseconds>(select AVG(track.milliseconds) from track)
order by milliseconds desc
/* Q7: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and 
total spent */
WITH popular_genre AS 
(
    SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id, 
	ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo 
    FROM invoice_line 
	JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	JOIN customer ON customer.customer_id = invoice.customer_id
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN genre ON genre.genre_id = track.genre_id
	GROUP BY 2,3,4
	ORDER BY 2 ASC, 1 DESC
)
SELECT * FROM popular_genre WHERE RowNo <= 1
