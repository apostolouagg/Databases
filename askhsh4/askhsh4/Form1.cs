using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Npgsql;

namespace askhsh4
{
    public partial class Form1 : Form
    {
        // Obtain connection string information from the portal
        private static string Host = "localhost";
        private static string User = "postgres";
        private static string DBname = "KuriosNektarios";
        private static string Password = "12102001Aa";

        private NpgsqlConnection connection;
        private string connectionstring = $"Host={Host};Username={User};Password={Password};Database={DBname}";

        public Form1()
        {
            InitializeComponent();
            connection = new NpgsqlConnection(connectionstring);
        }

        // A //
        private void buttonA_Click(object sender, EventArgs e)
        {
            connection.Open();

            NpgsqlCommand cmd = new NpgsqlCommand();
            cmd.Connection = connection;
            cmd.CommandText = "select insurance.contract_code,drivers_name,client_full_name,start_date from drivers inner join client on drivers.contract_code=client.contract_code inner join insurance on drivers.contract_code=insurance.contract_code where extract (month from start_date)=extract (month from current_date) and extract(year from start_date)= extract(year from current_date );";

            NpgsqlDataReader reader = cmd.ExecuteReader();
            DataTable dt = new DataTable();

            if (reader.HasRows)
            {
                dt.Load(reader);
                dataGridViewShowData.DataSource = dt;
            }

            connection.Close();
        }

        // B //
        private void buttonB_Click(object sender, EventArgs e)
        {
            connection.Open();

            NpgsqlCommand cmd = new NpgsqlCommand();
            cmd.Connection = connection;
            cmd.CommandText = "select insurance.contract_code, phone_number,end_date from insurance inner join client on insurance.contract_code=client.contract_code where end_date>date_trunc('month', current_date + interval '1' month);";

            NpgsqlDataReader reader = cmd.ExecuteReader();
            DataTable dt = new DataTable();

            if (reader.HasRows)
            {
                dt.Load(reader);
                dataGridViewShowData.DataSource = dt;
            }

            connection.Close();
        }

        // C //
        private void buttonC_Click(object sender, EventArgs e)
        {
            connection.Open();

            NpgsqlCommand cmd = new NpgsqlCommand();
            cmd.Connection = connection;
            cmd.CommandText = "select count (contract_code), insurance_category, case when extract(year from start_date)=2016 then '2016' when extract(year from start_date)=2017 then '2017' when extract(year from start_date)=2018 then '2018' when extract(year from start_date)=2019 then '2019' when  extract(year from start_date)=2020 then '2020' else 'other' end as start_year from insurance inner join incat on idincat=ins group by insurance_category,start_year order by start_year;";

            NpgsqlDataReader reader = cmd.ExecuteReader();
            DataTable dt = new DataTable();

            if (reader.HasRows)
            {
                dt.Load(reader);
                dataGridViewShowData.DataSource = dt;
            }

            connection.Close();
        }

        // D1 //
        private void buttonD_Click(object sender, EventArgs e)
        {
            connection.Open();

            NpgsqlCommand cmd = new NpgsqlCommand();
            cmd.Connection = connection;
            cmd.CommandText = "select sum (TO_NUMBER(contract_cost,'L9G999g999.99')) as total ,insurance_category from insurance inner join incat on ins=idincat group by insurance_category order by sum (TO_NUMBER(contract_cost,'L9G999g999.99'));";

            NpgsqlDataReader reader = cmd.ExecuteReader();
            DataTable dt = new DataTable();

            if (reader.HasRows)
            {
                dt.Load(reader);
                dataGridViewShowData.DataSource = dt;
            }

            connection.Close();
        }

        // D2 //
        private void buttonD2_Click(object sender, EventArgs e)
        {
            connection.Open();

            NpgsqlCommand cmd = new NpgsqlCommand();
            cmd.Connection = connection;
            cmd.CommandText = "select count(contract_code),avg(TO_NUMBER(contract_cost,'L9G999g999.99')) as average_contract_cost,insurance_category, avg(TO_NUMBER(contract_cost,'L9G999g999.99'))*count(contract_code) as total from insurance inner join incat on ins=idincat group by insurance_category;";

            NpgsqlDataReader reader = cmd.ExecuteReader();
            DataTable dt = new DataTable();

            if (reader.HasRows)
            {
                dt.Load(reader);
                dataGridViewShowData.DataSource = dt;
            }

            connection.Close();
        }

        // E //
        private void buttonE_Click(object sender, EventArgs e)
        {
            connection.Open();

            NpgsqlCommand cmd = new NpgsqlCommand();
            cmd.Connection = connection;
            cmd.CommandText = "select CASE WHEN EXTRACT(year from current_date)-EXTRACT(year from birthday) < 24 then '18-24' WHEN EXTRACT(year from current_date)-EXTRACT(year from birthday) between 25 and 49 then '25-49' WHEN EXTRACT(year from current_date)-EXTRACT(year from birthday) between 50 and 69 then '50-69' else '70+' End as driver_age,count(*) * 100 / (select count(*)from violation_participants) FROM violation_participants inner join drivers on involved_drivers = drivers_license_number group by driver_age; ";

            NpgsqlDataReader reader = cmd.ExecuteReader();
            DataTable dt = new DataTable();

            if (reader.HasRows)
            {
                dt.Load(reader);
                dataGridViewShowData.DataSource = dt;
            }

            connection.Close();
        }

        // F //
        private void buttonF_Click(object sender, EventArgs e)
        {
            connection.Open();

            NpgsqlCommand cmd = new NpgsqlCommand();
            cmd.Connection = connection;
            cmd.CommandText = "select CASE WHEN abs(release_year-EXTRACT(year from current_date)) < 5 then '0-5' WHEN abs(release_year-EXTRACT(year from current_date)) between 6 and 10 then '6-10' WHEN abs(release_year-EXTRACT(year from current_date)) between 11 and 15 then '11-15' WHEN abs(release_year-EXTRACT(year from current_date)) between 16 and 20 then '16-20' when abs(release_year-EXTRACT(year from current_date))> 20 then '20+' End as car_age ,count(*) * 100 / (select count(*)from cars) FROM cars GROUP BY car_age; ";

            NpgsqlDataReader reader = cmd.ExecuteReader();
            DataTable dt = new DataTable();

            if (reader.HasRows)
            {
                dt.Load(reader);
                dataGridViewShowData.DataSource = dt;
            }

            connection.Close();
        }
    }
}
